{
  nixpkgs,
  constants,
  ...
}:

let
  inherit (constants) dotsRepoPath system;
  inherit (nixpkgs) lib;
  inherit (lib)
    strings
    attrsets
    filesystem
    throwIf
    ;
  pkgs = nixpkgs.legacyPackages.${system};
in

rec {
  # Capitalize first letter
  toUpperCaseFirstLetter =
    string:
    let
      head = strings.toUpper (strings.substring 0 1 string);
      tail = strings.substring 1 (-1) string;
    in
    head + tail;

  # Split words around space, dash - and underscore _
  splitWords =
    string:
    # builtins.split returns non-matches (as string) interleaved with the matches (as list), so we filter by string
    builtins.filter builtins.isString (
      # we split by space, dash - and underscore _
      builtins.split "[ _-]" string
    );

  # Convert a string to PascalCase
  toPascalCase = string: strings.concatMapStrings toUpperCaseFirstLetter (splitWords string);

  # Convert a string to PascalCase with spaces in between words
  toPascalCaseWithSpaces =
    string: strings.concatMapStringsSep " " toUpperCaseFirstLetter (splitWords string);

  # Write a script just like pkgs.writeShellScriptBin and pkgs.writeScriptBin, but optionally add some dependencies.
  # Is automatically wrapped in another script with the deps on the PATH.
  writeScriptWithDeps =
    {
      name,
      file ? null,
      text ? builtins.readFile file,
      deps ? [ ],
      shell ? false,
    }:
    let
      scriptText = throwIf (text == null) "script needs text" text;
      builder = if shell then pkgs.writeShellScriptBin else pkgs.writeScriptBin;
    in
    pkgs.writeShellScriptBin name ''
      for i in ${strings.concatStringsSep " " deps}; do
        export PATH="$i/bin:$PATH"
      done

      exec ${builder "${name}-no-deps" scriptText}/bin/${name}-no-deps $@
    '';

  # Sanitize a path so that it doesn't cause problems in the nix store
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = strings.sanitizeDerivationName (builtins.baseNameOf path);
    };

  # Recursively find modules in a given directory and map them to a logical set:
  # dir/a/b/file.ext         => .a.b.file
  # dir/a/b/file/default.nix => .a.b.file
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
                  # ... then search for a default file (ie. default.nix, ...)
                  files = builtins.readDir filePath;
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

  # Utility to easily create a new global keybind.
  # Currently only implemented for Gnome
  mkGlobalKeybind =
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
      {
        config,
        pkgs,
        constants,
        ...
      }:
      {
        programs.dconf.enable = true;

        home-manager.users.${constants.user} = {
          # Create an extra script for the keybind, this avoids a bunch of weird issues
          home.packages = [
            (pkgs.writeShellScriptBin scriptName command)
          ];

          # Add the keybind to dconf
          dconf.settings =
            if config.desktop.gnome.enable then
              {
                "org/gnome/settings-daemon/plugins/media-keys" = {
                  custom-keybindings = [
                    "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}/"
                  ];
                };

                "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}" = {
                  inherit binding name;
                  command = scriptName;
                };
              }
            else
              (builtins.abort "gnome disabled, cannot create keybind!");
        };
      }
    );

  # Add a path that is to be synced between its destination and here in the repo
  mkSyncedPath =
    {
      xdgPath,
      cfgPath,
      excludes ? [ ],
    }:
    # Module to be imported
    {
      pkgs,
      constants,
      ...
    }:
    {
      config.home-manager.users.${constants.user} =
        { lib, config, ... }:
        {
          home.activation."sync-path-${builtins.toString xdgPath}" =

            let
              rsync = "${pkgs.rsync}/bin/rsync";

              cfgPathStr = "${dotsRepoPath}/config/${cfgPath}";
              xdgPathStr = "${config.xdg.configHome}/${builtins.toString xdgPath}";
              excludesArgs = lib.concatMapStrings (ex: ''--exclude="${ex}" '') excludes;
            in

            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              # Make sure both parent dirs exist
              mkdir --parents "${builtins.dirOf cfgPathStr}"
              mkdir --parents "${builtins.dirOf xdgPathStr}"

              # Backup old dir/file
              if [ -e "${xdgPathStr}" ]; then
                cp "${xdgPathStr}" "${xdgPathStr}.bak" -r --force
              fi

              if [ -d "${xdgPathStr}" ]; then
                # Is a dir, we need the trailing slash because rsync
                
                # Copy path to dots
                ${rsync} --ignore-times -r ${excludesArgs} "${xdgPathStr}/" "${cfgPathStr}"
                
                # Copy merged path back to xdg
                ${rsync} --ignore-times -r "${cfgPathStr}/" "${xdgPathStr}"
              else
                # Is a file
                cp "${xdgPathStr}" "${cfgPathStr}"
                cp "${cfgPathStr}" "${xdgPathStr}"
              fi
            '';
        };
    };

  # Add a file that is to be synced between its destination and here in the repo
  # This is so that whenever the file changes at the destionation (changed through the program ui for example),
  # it gets copied to the nix config repo. But also if the file is missing from the destination, it automatically
  # is added there.
  # Any differences between the two files are merged automatically, with the destination file having priority.
  # The file format needs to be convertible to- and from nix, to be able to merge the files properly.
  mkSyncedMergedFile =
    {
      toNix,
      fromNix,
      fallback ? "",
    }:
    {
      xdgPath,
      cfgPath,
      defaultOverrides ? { },
    }:

    let
      readOrDefault =
        file: if filesystem.pathIsRegularFile file then builtins.readFile file else fallback;
    in
    # Module to be imported
    {
      lib,
      config,
      pkgs,
      constants,
      ...
    }:
    let
      overrides = config.syncedFiles.overrides.${cfgPath};
    in
    {
      options.syncedFiles.overrides.${cfgPath} = lib.mkOption { default = { }; };

      config.home-manager.users.${constants.user} =
        { lib, config, ... }:
        {
          home.activation."sync-file-${builtins.toString xdgPath}" =

            let
              cfgPathStr = "${dotsRepoPath}/config/${cfgPath}";
              xdgPathStr = "${config.xdg.configHome}/${builtins.toString xdgPath}";
              src = toNix (readOrDefault cfgPathStr);
              xdg = toNix (readOrDefault xdgPathStr);
              merged = src // xdg // defaultOverrides;
              finalSrc = fromNix merged;
              finalXdg = fromNix (merged // overrides);
            in

            lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              # Make sure both dirs exist
              mkdir --parents "${builtins.dirOf cfgPathStr}"
              mkdir --parents "${builtins.dirOf xdgPathStr}"

              # Save new merged content to dots
              cat >"${cfgPathStr}" <<'EOL'
              ${finalSrc}
              EOL

              # Backup old file
              if [ -f "${xdgPathStr}" ]; then
                cp "${xdgPathStr}" "${xdgPathStr}.bak" --force
              fi

              # Save merged content to xdg file
              cat >"${xdgPathStr}" <<'EOL'
              ${finalXdg}
              EOL
            '';
        };
    };

  # Specialized version of mkSyncedMergedFile for JSON
  mkSyncedMergedJSON =
    # let
    #   # Custom pretty json instead of builtins.toJSON
    #   toPrettyJSON = attrs: builtins.readFile ((pkgs.formats.json { }).generate "prettyJSON" attrs);
    # in
    mkSyncedMergedFile {
      toNix = builtins.fromJSON;
      fromNix = builtins.toJSON;
      fallback = "{}";
    };

  # Create a shell alias that is shell-agnostic but still capable of looking up past commands
  mkShellHistoryAlias =
    {
      name,
      command,
    }:
    let
      historyCommands = {
        fish = ''$history[1]'';
        bash = ''$(fc -ln -1)'';
        zsh = ''''${history[@][1]}'';
      };

      mappedCommands = builtins.mapAttrs (
        _: lastCommand: command { inherit lastCommand; }
      ) historyCommands;
    in
    { constants, ... }:
    {
      home-manager.users.${constants.user} = {
        programs.bash.shellAliases.${name} = mappedCommands.bash;
        programs.fish.shellAliases.${name} = ''eval ${mappedCommands.fish}'';
        programs.zsh.shellAliases.${name} = ''eval ${mappedCommands.zsh}'';
      };
    };

  mkDesktopItem =
    {
      package ? null,
      name ? package.name or package.pname,
      desktopName ? toPascalCaseWithSpaces name,
      exec ? package,
      icon ? null,
      keywords ? [ name ],
      categories ? [ ],
    }:
    let
      desktopItemPackage =
        {
          stdenv,
          makeDesktopItem,
          copyDesktopItems,
          directories,
        }:
        stdenv.mkDerivation (finalAttrs: {
          pname = "${name}-desktop-icon";
          version = "0.0.0";
          dontUnpack = true;
          nativeBuildInputs = [ copyDesktopItems ];
          desktopItems = (
            makeDesktopItem {
              inherit
                name
                desktopName
                exec
                icon
                keywords
                categories
                ;
            }
          );
        });
    in
    {
      pkgs,
      constants,
      directories,
      ...
    }:
    {
      home-manager.users.${constants.user} = {
        home.packages = [
          (pkgs.callPackage desktopItemPackage { inherit directories; })
        ];
      };
    };

  # Apply one or more patches to a package without having to create an entire overlay for it
  mkQuickPatch =
    { package, patches }:
    { ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          ${package} = prev.${package}.overrideAttrs (
            finalAttrs: oldAttrs: { patches = (prev.patches or [ ]) ++ patches; }
          );
        })
      ];
    };

  # Options shortcut for a string option
  mkString = lib.options.mkOption {
    type = lib.types.str;
  };

  # Options shortcut for a boolean option with default of false
  mkBoolDefaultFalse = lib.options.mkOption {
    type = lib.types.bool;
    default = false;
  };

  # Options shortcut for a boolean option with default of true
  mkBoolDefaultTrue = lib.options.mkOption {
    type = lib.types.bool;
    default = true;
  };

  # Options shortcut for a submodule
  mkSubmodule =
    options:
    lib.options.mkOption {
      type = lib.types.submodule {
        inherit options;
      };
      default = { };
    };

}
