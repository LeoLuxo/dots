{
  cfg,
  lib,
  extraLib,
  constants,
  pkgs,
  ...
}:

let
  inherit (lib) options types filesystem;
  inherit (extraLib) mkAttrsOfSubmodule;
in
{
  options = {
    # Synchronize files/directories between this dots repo and a system xdg path
    # Destination changes take priority (when changed through a UI for example).
    #
    # Two modes of operation:
    # 1. Basic sync (type = null):
    #    - Maintains identical copies at source and destination
    #    - Works with both files and directories
    #    - Changes at destination are copied back to repo
    #
    # 2. File merge (type != null):
    #    - Only works with individual files (not directories)
    #    - Supports automatic merging of differences
    #    - File format must be convertible to/from Nix
    #    - The option <path>.overrides can be used to add merge overrides accross nixos modules

    syncedPaths = mkAttrsOfSubmodule {
      # <path> = Path relative to repo's config directory

      # Target path relative to XDG_CONFIG_HOME
      xdgPath = options.mkOption {
        type = types.str;
      };

      # Optional merge strategy for files
      type = options.mkOption {
        type = types.nullOr (types.enum [ "json" ]);
        default = null;
      };

      # Overrides to apply to the file after merging
      overrides = options.mkOption {
        type = types.attrs;
        default = { };
      };

      # Files to exclude when copying a directory
      excludes = options.mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = lib.mapAttrs' (
    cfgPath: syncedFile:

    let
      typeMap = {
        "json" = {
          toNix = builtins.fromJSON;
          fromNix = builtins.toJSON;
          fallback = "{}";
        };
      };

      merge = typeMap syncedFile.type;
    in
    {
      home-manager.users.${constants.user} =
        { lib, config, ... }:
        {
          config =
            let
              cfgPathStr = "${constants.dotsRepoPath}/config/${cfgPath}";
              xdgPathStr = "${config.xdg.configHome}/${builtins.toString syncedFile.xdgPath}";
            in
            {
              home.activation."sync-path-${cfgPath}" = lib.hm.dag.entryAfter [ "writeBoundary" ] (
                ''
                  # Make sure both parent dirs exist
                  mkdir --parents "${builtins.dirOf cfgPathStr}"
                  mkdir --parents "${builtins.dirOf xdgPathStr}"

                  # Backup old dir/file
                  if [ -e "${xdgPathStr}" ]; then
                    cp "${xdgPathStr}" "${xdgPathStr}.bak" -r --force
                  fi

                ''
                + (
                  if merge != null then
                    # For merged files
                    let
                      readOrDefault =
                        file: if filesystem.pathIsRegularFile file then builtins.readFile file else merge.fallback;

                      src = merge.toNix (readOrDefault cfgPathStr);
                      xdg = merge.toNix (readOrDefault xdgPathStr);
                      merged = src // xdg // merge.defaultOverrides;
                      finalSrc = merge.fromNix merged;
                      finalXdg = merge.fromNix (merged // syncedFile.overrides);
                    in
                    ''
                      # Save new merged content to dots
                      cat >"${cfgPathStr}" <<'EOL'
                      ${finalSrc}
                      EOL

                      # Save merged content to xdg file
                      cat >"${xdgPathStr}" <<'EOL'
                      ${finalXdg}
                      EOL
                    ''
                  else
                    # For raw files/dirs
                    let
                      rsync = "${pkgs.rsync}/bin/rsync";
                      excludesArgs = lib.concatMapStrings (ex: ''--exclude="${ex}" '') syncedFile.excludes;
                    in
                    ''
                      if [ -d "${xdgPathStr}" ]; then
                        # Is a dir, we need the trailing slash because rsync

                        # Copy path to dots
                        ${rsync} --ignore-times -r ${excludesArgs} "${xdgPathStr}/" "${cfgPathStr}"

                        # Copy merged path back to xdg
                        ${rsync} --ignore-times -r "${cfgPathStr}/" "${xdgPathStr}"
                      else
                        # Is a file
                        cp "${xdgPathStr}" "${cfgPathStr}" --force || true
                        cp "${cfgPathStr}" "${xdgPathStr}" --force
                      fi
                    ''
                )
              );
            };
        };
    }
  ) cfg.syncedPaths;
}
