{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.ext.scripts.nx.configSync;
in
{
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
  options.ext.scripts.nx.configSync = with lib2.options; {
    enable = lib.mkEnableOption "nx config sync";

    path =
      mkOpt "Location of the config sync directory" types.path
        "${config.ext.scripts.nx.variables.NX_DOTS}/config";

    paths = mkAttrsSub' "Files/directories to sync and optionally merge" {
      # <path> = Path relative to repo's config directory
      xdgPath = mkOpt' "Target path relative to XDG_CONFIG_HOME" types.str;
      mergeType = mkNullOr "Optional merge strategy for files" (types.enum [ "json" ]);
      overrides = mkOpt "Overrides to apply to the file after merging" types.attrs { };
      excludes = mkOpt "Files to exclude when copying a directory" (types.listOf types.str) [ ];
    };
  };

  config = lib.mkIf cfg.enable (
    let
      scriptFile = lib.path.removePrefix config.ext.system.user.home config.ext.scripts.nx.variables.NX_CONFIG_SYNC;

      typeMap = {
        "json" = {
          toNix = builtins.fromJSON;
          fromNix = builtins.toJSON;
          fallback = "{}";
        };
      };
    in

    lib.mapAttrs' (syncName: syncFile: {
      ext.hm =
        hmArgs:
        let
          merge = typeMap syncFile.mergeType;
          cfgPathStr = "${cfg.path}/${syncName}";
          xdgPathStr = "${hmArgs.config.xdg.configHome}/${builtins.toString syncFile.xdgPath}";
        in
        {
          home.file.${scriptFile}.text = (
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
                    file: if lib.filesystem.pathIsRegularFile file then builtins.readFile file else merge.fallback;

                  src = merge.toNix (readOrDefault cfgPathStr);
                  xdg = merge.toNix (readOrDefault xdgPathStr);
                  merged = src // xdg // merge.defaultOverrides;
                  finalSrc = merge.fromNix merged;
                  finalXdg = merge.fromNix (merged // syncFile.overrides);
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
                  excludesArgs = lib.concatMapStrings (ex: ''--exclude="${ex}" '') syncFile.excludes;
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
    }) cfg
  );
}
