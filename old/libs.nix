{
  inputs,
  constants,
  ...
}:

let
  inherit (constants) nixosRepoPath system;
  inherit (inputs.nixpkgs) lib;
  inherit (lib)
    strings
    attrsets
    filesystem
    throwIf
    lists
    ;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in

rec {
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = strings.sanitizeDerivationName (builtins.baseNameOf path);
    };

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

  # Replace variables in place in the script text
  replaceScriptVariables =
    script: variables:
    let
      varNames1 = lists.map (x: "$" + x) (attrsets.attrNames variables);
      varNames2 = lists.map (x: "\${" + x + "}") (attrsets.attrNames variables);
      varValues = attrsets.attrValues variables;
    in
    strings.replaceStrings (varNames1 ++ varNames2) (varValues ++ varValues) script;

  # Write a script just like pkgs.writeShellScriptBin and pkgs.writeScriptBin, but optionally add some dependencies.
  # Is automatically wrapped in another script with the deps on the PATH.
  writeScriptWithDeps =
    {
      name,
      file ? null,
      text ? builtins.readFile file,
      deps ? [ ],
      addBashShebang ? false,
      binFolder ? true,
      replaceVariables ? { },
      elevate ? false,
    }:
    let
      scriptTextPreVars = throwIf (text == null) "script needs text" text;
      scriptText = replaceScriptVariables scriptTextPreVars replaceVariables;

      # https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
      innerBuilder = if addBashShebang then pkgs.writeShellScript else pkgs.writeScript;
      outerBuilder = if binFolder then pkgs.writeShellScriptBin else pkgs.writeShellScript;

      # Using sudo to elevate the script
      elevation = if elevate then ''sudo'' else "";
    in
    outerBuilder name ''
      for i in ${strings.concatStringsSep " " deps}; do
        export PATH="$i/bin:$PATH"
      done

      exec ${elevation} ${innerBuilder "${name}-no-deps" scriptText} $@
    '';

  # Write a nushell script akin to writeScriptWithDeps
  writeNushellScript =
    {
      name,
      file ? null,
      text ? null,
      deps ? [ ],
      elevate ? false,
      binFolder ? true,
    }@args:
    writeScriptWithDeps (
      args
      // {
        addBashShebang = false;
        text =
          if file == null then
            ''
              #!${pkgs.nushell}/bin/nu
              ${throwIf (text == null) "script needs text" text}
            ''
          else
            ''
              #!${pkgs.bash}/bin/bash
              ${pkgs.nushell}/bin/nu ${file}
            '';
      }
    );

  # Utility to easily create a new global keybind.
  # Currently only implemented for Gnome
  # mkGlobalKeybind =
  #   {
  #     name,
  #     binding,
  #     command,
  #   }:
  #   (
  #     let
  #       id = strings.toLower (strings.sanitizeDerivationName name);
  #       scriptName = "keybind-${id}";
  #     in
  #     # Module to be imported
  #     {
  #       config,
  #       pkgs,
  #       constants,
  #       ...
  #     }:
  #     {
  #       programs.dconf.enable = true;

  #       # Create an extra script for the keybind, this avoids a bunch of weird issues
  #       my.packages = [
  #         (pkgs.writeShellScriptBin scriptName command)
  #       ];

  #       home-manager.users.${config.my.user.name} = {
  #         # Add the keybind to dconf
  #         dconf.settings =
  #           if config.desktop.gnome.enable then
  #             {
  #               "org/gnome/settings-daemon/plugins/media-keys" = {
  #                 custom-keybindings = [
  #                   "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}/"
  #                 ];
  #               };

  #               "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}" = {
  #                 inherit binding name;
  #                 command = scriptName;
  #               };
  #             }
  #           else
  #             (builtins.abort "gnome disabled, cannot create keybind!");
  #       };
  #     }
  #   );

  # Synchronize files/directories between this dots repo and a system xdg path
  # Destination changes take priority (when changed through a UI for example).
  #
  # Two modes of operation:
  # 1. Basic sync (merge = null):
  #    - Maintains identical copies at source and destination
  #    - Works with both files and directories
  #    - Changes at destination are copied back to repo
  #
  # 2. File merge (merge != null):
  #    - Only works with individual files (not directories)
  #    - Supports automatic merging of differences
  #    - File format must be convertible to/from Nix
  #    - The option syncedFiles.overrides.<path> can be used to add more merge overrides accross nixos modules
  #
  # Parameters:
  #   cfgPath  - Path relative to repo's config directory
  #   xdgPath  - Target path relative to XDG_CONFIG_HOME
  #   merge    - Optional merge strategy for files
  mkSyncedPath =
    {
      xdgPath,
      cfgPath,
      excludes ? [ ],
      merge ? null, # Optional merge config for single files
    }:
    # Module to be imported
    {
      lib,
      pkgs,
      config,
      constants,
      ...
    }:
    {
      options =
        if merge != null then
          {
            syncedFiles.overrides.${cfgPath} = lib.mkOption { default = { }; };
          }
        else
          { };

      config.home-manager.users.${config.my.user.name} =
        let
          outerConfig = config;
        in
        { lib, config, ... }:
        {
          config =
            let
              cfgPathStr = "${nixosRepoPath}/config/${cfgPath}";
              xdgPathStr = "${config.xdg.configHome}/${builtins.toString xdgPath}";
            in
            {
              # assertions = [
              #   {
              #     assertion = filesystem.pathIsDirectory xdgPathStr -> merge == null;
              #     message = "Directories cannot be merged to and from Nix";
              #   }
              #   {
              #     assertion = excludes == [ ] || filesystem.pathIsDirectory xdgPathStr;
              #     message = "Exclusion patterns can only be applied on a directory";
              #   }
              # ];

              # DISABLED FOR NOW, MEGA BROKEN

              # home.activation."sync-path-${cfgPath}" = lib.hm.dag.entryAfter [ "writeBoundary" ] (
              #   ''
              #     # Make sure both parent dirs exist
              #     mkdir --parents "${builtins.dirOf cfgPathStr}"
              #     mkdir --parents "${builtins.dirOf xdgPathStr}"

              #     # Backup old dir/file
              #     if [ -e "${xdgPathStr}" ]; then
              #       cp "${xdgPathStr}" "${xdgPathStr}.bak" -r --force
              #     fi

              #   ''
              #   + (
              #     if merge != null then
              #       # For merged files
              #       let
              #         overrides = outerConfig.syncedFiles.overrides.${cfgPath};
              #         readOrDefault =
              #           file: if filesystem.pathIsRegularFile file then builtins.readFile file else merge.fallback;

              #         src = merge.toNix (readOrDefault cfgPathStr);
              #         xdg = merge.toNix (readOrDefault xdgPathStr);
              #         merged = src // xdg // merge.defaultOverrides;
              #         finalSrc = merge.fromNix merged;
              #         finalXdg = merge.fromNix (merged // overrides);
              #       in
              #       ''
              #         # Save new merged content to dots
              #         cat >"${cfgPathStr}" <<'EOL'
              #         ${finalSrc}
              #         EOL

              #         # Save merged content to xdg file
              #         cat >"${xdgPathStr}" <<'EOL'
              #         ${finalXdg}
              #         EOL
              #       ''
              #     else
              #       # For raw files/dirs
              #       let
              #         rsync = "${pkgs.rsync}/bin/rsync";
              #         excludesArgs = lib.concatMapStrings (ex: ''--exclude="${ex}" '') excludes;
              #       in
              #       ''
              #         if [ -d "${xdgPathStr}" ]; then
              #           # Is a dir, we need the trailing slash because rsync

              #           # Copy path to dots
              #           ${rsync} --ignore-times -r ${excludesArgs} "${xdgPathStr}/" "${cfgPathStr}"

              #           # Copy merged path back to xdg
              #           ${rsync} --ignore-times -r "${cfgPathStr}/" "${xdgPathStr}"
              #         else
              #           # Is a file
              #           cp "${xdgPathStr}" "${cfgPathStr}" --force || true
              #           cp "${cfgPathStr}" "${xdgPathStr}" --force
              #         fi
              #       ''
              #   )
              # );
            };
        };

    };

  # Helper function to create a merge config for JSON files
  mkJSONMerge =
    {
      defaultOverrides ? { },
    }:
    {
      toNix = builtins.fromJSON;
      fromNix = builtins.toJSON;
      fallback = "{}";
      inherit defaultOverrides;
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
    { constants, config, ... }:
    {
      home-manager.users.${config.my.user.name} = {
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
      exec ? "${package}/bin/${name}",
      icon ? null,
      keywords ? [ name ],
      categories ? [ ],
      elevate ? false,
    }:
    let
      # Using pkexec to elevate the script using the GUI-sudo-thing
      wrappedExec =
        if elevate then
          # Need to create an entire wrapped script because gnome complain about $ in the Exec field
          "${
            (writeScriptWithDeps {
              name = "${name}-desktop-icon-wrapper";
              text = ''pkexec env XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY PATH=$PATH ${exec}'';
            })
          }/bin/${name}-desktop-icon-wrapper"
        else
          exec;

      desktopItemPackage =
        {
          stdenv,
          makeDesktopItem,
          copyDesktopItems,
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
                icon
                keywords
                categories
                ;
              exec = wrappedExec;
            }
          );
        });
    in
    {
      pkgs,
      constants,
      ...
    }:
    {
      my.packages = [
        (pkgs.callPackage desktopItemPackage { })
      ];
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
  mkEmptyString = lib.options.mkOption {
    type = lib.types.str;
    default = "";
  };

  # Options shortcut for a lines option
  mkEmptyLines = lib.options.mkOption {
    type = lib.types.lines;
    default = "";
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
