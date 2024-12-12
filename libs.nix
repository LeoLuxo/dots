{
  nixpkgs,
  constants,
  ...
}:

let
  inherit (constants) dotsRepoPath system;
  inherit (nixpkgs) lib;
  inherit (lib) strings attrsets filesystem;
  pkgs = nixpkgs.legacyPackages.${system};
in

rec {
  writeScriptWithDeps =
    {
      name,
      text,
      deps ? [ ],
      shell ? false,
    }:
    let
      builder = if shell then pkgs.writeShellScriptBin else pkgs.writeScriptBin;
    in
    pkgs.writeShellScriptBin name ''
      for i in ${strings.concatStringsSep " " deps}; do
        export PATH="$i/bin:$PATH"
      done

      exec ${builder "${name}-no-deps" text}/bin/${name}-no-deps $@
    '';

  # Sanitize a path so that it doesn't cause problems in the nix store
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = strings.sanitizeDerivationName (baseNameOf path);
    };

  # Recursively find modules in a given directory and map them to a logical set:
  # dir/a/b/file.ext         => .a.b.file
  # dir/a/b/file/default.ext => .a.b.file
  findFiles =
    {
      dir,
      extensions,
      defaultFiles ? [ ],
    }:
    let
      extRegex = "(${strings.concatStrings (strings.intersperse "|" extensions)})";
      ignore = name: {
        name = "";
        value = null;
      };

      findFilesRecursive =
        dir:
        attrsets.filterAttrs
          # filter out ignored files/dirs
          (n: v: v != null)
          (
            attrsets.mapAttrs' (
              fileName: type:
              let
                extMatch = builtins.match "(.*)\\.${extRegex}" fileName;
                filePath = dir + "/${fileName}";
              in
              # If regular file, then add it to the file list only if the extension regex matches
              if type == "regular" then
                if extMatch == null then
                  ignore fileName
                else
                  {
                    # Filename without the extension
                    name = builtins.elemAt extMatch 0;
                    value = filePath;
                  }
              # If directory, ...
              else if type == "directory" then
                let
                  # ... then search for a default.ext file
                  files = builtins.readDir filePath;
                  # defaultFiles = map (ext: "default.${ext}") extensions;
                  hasDefault = builtins.any (defaultFile: files ? ${defaultFile}) defaultFiles; # builtins.any returns false given an empty list
                in
                # if a default file exists, add the directory to our file list
                if hasDefault then
                  {
                    name = fileName;
                    value = filePath;
                  }
                else
                  # otherwise search recursively in the directory,
                  # and map the results to a nested set with the name of the folder as top key.
                  # Also add the base directory path under the _dir key
                  {
                    name = fileName;
                    value = findFilesRecursive filePath // {
                      _dir = filePath;
                    };
                  }
              else
                # any other file types we ignore (i.e. symlink and unknown)
                ignore fileName
            ) (builtins.readDir dir)
          );
    in
    findFilesRecursive (sanitizePath dir);

  # Utility to easily create a new keybind
  mkGnomeKeybind =
    {
      name,
      binding,
      command,
    }:
    (
      let
        id = strings.toLower (strings.sanitizeDerivationName name);
        scriptName = "keybind-${id}";
      in
      # Module to be imported
      { pkgs, constants, ... }:
      {
        programs.dconf.enable = true;
        home-manager.users.${constants.user} = {
          # Create an extra script for the keybind, this avoids a bunch of weird issues
          home.packages = [
            (pkgs.writeShellScriptBin scriptName command)
          ];

          # Add the keybind to dconf
          dconf.settings = {
            "org/gnome/settings-daemon/plugins/media-keys" = {
              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}/"
              ];
            };

            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}" = {
              inherit binding name;
              command = scriptName;
            };
          };
        };
      }
    );

  mkSyncedJSON =
    let
      # Custom pretty json instead of builtins.toJSON
      toPrettyJSON = attrs: builtins.readFile ((pkgs.formats.json { }).generate "prettyJSON" attrs);
    in
    mkSyncedFile {
      toNix = builtins.fromJSON;
      fromNix = toPrettyJSON;
      fallback = "{}";
    };

  mkSyncedFile =
    {
      toNix,
      fromNix,
      fallback ? "",
    }:
    { syncPath, xdgPath }:

    let
      readOrDefault =
        file: if filesystem.pathIsRegularFile file then builtins.readFile file else fallback;
    in
    # Module to be imported
    { pkgs, constants, ... }:
    {
      home-manager.users.${constants.user} =
        { lib, config, ... }:
        {
          home.activation."sync file ${builtins.toString xdgPath}" =

            let
              syncPathStr = "${dotsRepoPath}/synced/${syncPath}";
              xdgPathStr = "${config.xdg.configHome}/${builtins.toString xdgPath}";
              src = toNix (readOrDefault syncPathStr);
              xdg = toNix (readOrDefault xdgPathStr);
              merged = fromNix (src // xdg);

            in

            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              # Save new merged content to dots
              cat >"${syncPathStr}" <<EOL
              ${merged}
              EOL

              # Backup old file
              if [ -f "${xdgPathStr}" ]; then
                cp "${xdgPathStr}" "${xdgPathStr}.bak" --force
              fi

              # Copy merged content to new file
              mkdir --parents "$(dirname "${xdgPathStr}")"
              cp "${syncPathStr}" "${xdgPathStr}" --force
            '';
        };
    };

  mkBoolDefaultFalse = lib.options.mkOption {
    type = lib.types.bool;
    default = false;
  };

  mkBoolDefaultTrue = lib.options.mkOption {
    type = lib.types.bool;
    default = true;
  };

  mkSubmodule =
    options:
    lib.options.mkOption {
      type = lib.types.submodule {
        inherit options;
      };
      default = { };
    };

}
