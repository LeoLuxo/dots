{ nixpkgs, system, ... }:

with nixpkgs.lib;
with builtins;
let
  pkgs = nixpkgs.legacyPackages.${system};

in
rec {
  directories = {
    modules = findFiles ./modules [ "nix" ] true;

    images = findFiles ./assets [
      "png"
      "jpg"
      "jpeg"
      "gif"
      "svg"
      "heic"
    ] false;

    icons = findFiles ./assets/icons [
      "ico"
      "icns"
    ] false;

    scripts = findFiles ./scripts [
      "sh"
      "nu"
      "py"
    ] true;
  };

  scriptBin =
    # Create scripts for every script file
    # (nix is maximally lazy so this only happens if  and when a script is added to the packages)
    # (Ignoring all _dir attributes)
    mapAttrsRecursive (
      path: value: pkgs.writeShellScriptBin (lists.last path) (builtins.readFile value)
    ) (attrsets.filterAttrsRecursive (n: v: n != "_dir") directories.scripts);

  # Recursively find modules in a given directory and map them to a logical set:
  # dir/a/b/file.ext         => .a.b.file
  # dir/a/b/file/default.ext => .a.b.file
  findFiles =
    dir: extensions: allowDefault:
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
                extMatch = (match "(.*)\\.${extRegex}" fileName);
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
    findFilesRecursive dir;

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

  mkScriptWithDeps =
    builder:
    {
      name,
      text,
      deps ? [ ],
    }:
    pkgs.writeShellScriptBin name ''
      for i in ${concatStringsSep " " deps}; do
        export PATH="$i/bin:$PATH"
      done

      exec ${builder "${name}-no-deps" text} $@
    '';

  writeScriptBinWithDeps = mkScriptWithDeps pkgs.writeScriptBin;
  writeShellScriptBinWithDeps = mkScriptWithDeps pkgs.writeShellScriptBin;

}
