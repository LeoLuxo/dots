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
