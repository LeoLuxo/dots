{
  nixpkgs,
  system,
  nixRepoPath,
  ...
}:

with nixpkgs.lib;
with builtins;
let
  pkgs = nixpkgs.legacyPackages.${system};

in
rec {
  directories = rec {
    modules = findFiles {
      dir = ./modules;
      extensions = [ "nix" ];
      allowDefault = true;
    };

    scripts = findFiles {
      dir = ./scripts;
      extensions = [
        "sh"
        "nu"
        "py"
      ];
      allowDefault = true;
    };

    images = findFiles {
      dir = ./assets;
      extensions = [
        "png"
        "jpg"
        "jpeg"
        "gif"
        "svg"
        "heic"
      ];
    };

    wallpapers = images.wallpapers;

    icons = findFiles {
      dir = ./assets/icons;
      extensions = [
        "ico"
        "icns"
      ];
    };
  };

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
      for i in ${concatStringsSep " " deps}; do
        export PATH="$i/bin:$PATH"
      done

      exec ${builder "${name}-no-deps" text}/bin/${name}-no-deps $@
    '';

  # Create scripts for every script file
  scriptBin =
    # (nix is maximally lazy so this is only run if  and when a script is added to the packages)
    mapAttrsRecursive (
      path: value:
      let
        filename = lists.last path;
      in
      {
        rename ? filename,
        deps ? [ ],
        shell ? false,
      }:
      writeScriptWithDeps {
        name = rename;
        text = (builtins.readFile value);
        inherit deps shell;
      }
      # (Ignores all _dir attributes)
    ) (attrsets.filterAttrsRecursive (n: v: n != "_dir") directories.scripts);

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
      allowDefault ? false,
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
                extMatch = match "(.*)\\.${extRegex}" fileName;
                filePath = dir + "/${fileName}";
              in
              # If regular file, then add it to the file list only if the extension regex matches
              if type == "regular" then
                if extMatch == null then
                  ignore fileName
                else
                  {
                    # Filename without the extension
                    name = elemAt extMatch 0;
                    value = filePath;
                  }
              # If directory, ...
              else if type == "directory" then
                let
                  # ... then search for a default.ext file
                  files = readDir filePath;
                  defaultFiles = map (ext: "default.${ext}") extensions;
                  hasDefault = any (defaultFile: files ? ${defaultFile}) defaultFiles;
                in
                # if the default file exists, add the directory to our file list
                if allowDefault && hasDefault then
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
            ) (readDir dir)
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
      { pkgs, user, ... }:
      {
        programs.dconf.enable = true;
        home-manager.users.${user} = {
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
      toPrettyJSON = attrs: readFile ((pkgs.formats.json { }).generate "prettyJSON" attrs);
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
    { pkgs, user, ... }:
    {
      home-manager.users.${user} =
        { lib, config, ... }:
        {
          home.activation."sync file ${builtins.toString xdgPath}" =

            let
              syncPathStr = "${nixRepoPath}/synced/${syncPath}";
              xdgPathStr = "${config.xdg.configHome}/${builtins.toString xdgPath}";
              src = toNix (readOrDefault syncPathStr);
              xdg = toNix (readOrDefault xdgPathStr);
              merged = fromNix (src // xdg);

            in

            # '''';
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
              cp "${syncPathStr}" "${xdgPathStr}" --force
            '';
        };

      # system.userActivationScripts."mkSyncedFile ${builtins.toString xdgPath}" = {
      #   text = ''
      #     # Save new merged content to dots
      #     cat >"${builtins.toString syncPath}" <<EOL
      #     ${merged}
      #     EOL

      #     # Backup old file
      #     cp "${builtins.toString xdgPath}" "${builtins.toString xdgPath}.bak" --force
      #     # Copy merged content to new file
      #     cp "${builtins.toString syncPath}" "${builtins.toString xdgPath}" --force
      #   '';
      #   deps = [ ];
      # };
    };

}
