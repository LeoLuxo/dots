{
  pkgs,
  lib,
  config,
  inputs,
  extraLib,
  ...
}:

let

  inherit (lib) types;
  inherit (lib.my) writeFile notNullOr;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;

  inherit (extraLib)
    mkShellHistoryAlias
    writeScriptWithDeps
    mkSubmodule
    ;

  cfg = config.my.nx;
  cfgPaths = config.my.paths;
in

let
  mkEmptyLines = mkOption {
    type = types.lines;
    default = "";
  };

  mkPathEntry =
    args:
    mkOption {
      type = types.nullOr types.path;
      default = null;
    }
    // args;
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index

    (mkShellHistoryAlias {
      name = ",,";
      command = { lastCommand }: '', ${lastCommand}'';
    })
  ];

  options = {
    my.nx = {
      enable = mkEnableOption "nix utilities";

      rebuild = mkSubmodule {
        preRebuildActions = mkEmptyLines;
        postRebuildActions = mkEmptyLines;
      };
    };

    my.paths = {

      nx = mkPathEntry {
        description = "default path for all nix-utility-related stuff";
        default = "${cfgPaths.home}/.nx";
      };

      dconfDiff = mkPathEntry {
        description = "path where nx-dconf-diff should save its data";
        default = "${cfgPaths.nx}/dconf_diff";
      };

      preRebuild = mkPathEntry {
        description = "path where nx-rebuild should source its pre-rebuild script";
        default = "${cfgPaths.nx}/pre_rebuild.sh";
      };

      postRebuild = mkPathEntry {
        description = "path where nx-rebuild should source its post-rebuild script";
        default = "${cfgPaths.nx}/post_rebuild.sh";
      };

      nixosTodo = mkPathEntry {
        description = "path of the NixOS TODO-list";
      };
    };
  };

  config = mkIf cfg.enable (
    let
      variables = {
        # Set the location of the dots repo
        NX_DOTS = notNullOr cfgPaths.nixosRepo "";

        # Set the location of the file used for dconf-diff
        NX_DCONF_DIFF = notNullOr cfgPaths.dconfDiff "";

        # Set the location of the files used for nx-rebuild
        NX_PRE_REBUILD = notNullOr cfgPaths.preRebuild "";
        NX_POST_REBUILD = notNullOr cfgPaths.postRebuild "";

        # Set the location of the todo doc
        NX_TODO = notNullOr cfgPaths.nixosTodo "";
      };
    in
    {
      warnings = (
        lib.optionals (cfgPaths.nixosRepo == null) [
          "The nx option is enabled but paths.nixosRepo is not set, expect some breakage."
        ]
        ++ lib.optionals (cfgPaths.dconfDiff == null) [
          "The nx option is enabled but paths.dconfDiff is not set, expect some breakage."
        ]
        ++ lib.optionals (cfgPaths.preRebuild == null) [
          "The nx option is enabled but paths.preRebuild is not set, expect some breakage."
        ]
        ++ lib.optionals (cfgPaths.postRebuild == null) [
          "The nx option is enabled but paths.postRebuild is not set, expect some breakage."
        ]
        ++ lib.optionals (cfgPaths.nixosTodo == null) [
          "The nx option is enabled but paths.nixosTodo is not set, expect some breakage."
        ]
      );

      # Set environment variables
      environment.variables = variables;

      # Install comma via nix-index so that it's wrapped correctly
      # Comma can run non-installed packages by prepending the command with a ','
      programs.nix-index-database.comma.enable = true;
      # But disable nix-index hook into command-not-found because I don't like its delay
      programs.nix-index.enable = false;

      # Add some post-build actions
      my.nx.rebuild.postRebuildActions = mkIf (cfgPaths.dconfDiff != null) ''
        # Save current dconf settings (for nx-dconf-diff)
        echo "Dumping dconf"
        mkdir --parents "$(dirname "${cfgPaths.dconfDiff}")" && touch "${cfgPaths.dconfDiff}"
        dconf dump / >"${cfgPaths.dconfDiff}"
      '';

      # Add nx scripts and other packages
      my.packages = with pkgs; [
        # Nix helper utilities
        nh
        nurl
        nix-init

        (writeScriptWithDeps {
          name = "nx-cleanup";
          file = ./scripts/nx-cleanup.sh;
          deps = [ nh ];
          replaceVariables = variables;
        })

        (mkIf (cfgPaths.nixosRepo != null) (writeScriptWithDeps {
          name = "nx-rebuild";
          file = ./scripts/nx-rebuild.sh;
          deps = [
            dconf
            git
            nixfmt-rfc-style
            nh
          ];
          replaceVariables = variables;
        }))

        (mkIf (cfgPaths.nixosRepo != null) (writeScriptWithDeps {
          name = "nx-code";
          file = ./scripts/nx-code.sh;
          replaceVariables = variables;
        }))

        (mkIf (cfgPaths.nixosRepo != null) (writeScriptWithDeps {
          name = "nx-template";
          file = ./scripts/nx-template.sh;
          replaceVariables = variables;
        }))

        (mkIf (cfgPaths.nixosTodo != null) (writeScriptWithDeps {
          name = "nx-todo";
          file = ./scripts/nx-todo.sh;
          replaceVariables = variables;
        }))

        (mkIf (cfgPaths.dconfDiff != null) (writeScriptWithDeps {
          name = "nx-dconf-diff";
          file = ./scripts/nx-dconf-diff.sh;
          deps = [
            dconf
            difftastic
          ];
          replaceVariables = variables;
        }))
      ];

      my.keybinds = {
        "Open nx-code" = mkIf (cfgPaths.nixosRepo != null) {
          binding = "<Super>F9";
          command = "nx-code";
        };

        "Open nx-todo" = mkIf (cfgPaths.nixosTodo != null) {
          binding = "<Super>F10";
          command = "nx-todo";
        };
      };

      system.userActivationScripts = {
        # Set up pre- and post actions for nx-rebuild
        writePreRebuild = mkIf (cfgPaths.preRebuild != null) (writeFile {
          path = cfgPaths.preRebuild;
          text = cfg.rebuild.preRebuildActions;
          force = true;
        });

        writePostRebuild = mkIf (cfgPaths.postRebuild != null) (writeFile {
          path = cfgPaths.postRebuild;
          text = cfg.rebuild.postRebuildActions;
          force = true;
        });
      };

      home-manager.users.${config.my.user.name} = {
        # Add aliases
        home.shellAliases = {
          nx-cd = "cd $NX_DOTS";
          nxcd = "nx-cd";

          nxr = "nx-rebuild";

          nx-edit = "nx-code";
          nx-search = "nh search --limit 4";
        };
      };
    }
  );

}
