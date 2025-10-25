{
  config,
  dots,
  dotsTodo,
  inputs,
  lib,
  lib2,
  pkgs,
  user,
  ...
}:

let
  inherit (lib) types;
  inherit (lib2)
    writeFile
    notNullOr
    mkShellHistoryAlias
    mkSubmodule
    ;
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.scripts.nx;
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

  paths = rec {
    nx = "/home/${user}/.nx";
    dconfDiff = "${nx}/dconf_diff";
    preRebuild = "${nx}/pre_rebuild.sh";
    postRebuild = "${nx}/post_rebuild.sh";
  };
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
    my.scripts.nx = {
      enable = mkEnableOption "nix utilities";

      rebuild = mkSubmodule {
        preRebuildActions = mkEmptyLines;
        postRebuildActions = mkEmptyLines;
      };
    };
  };

  config = mkIf cfg.enable (
    let
      variables = {
        # Set the location of the dots repo
        NX_DOTS = dots;

        # Set the location of the file used for dconf-diff
        NX_DCONF_DIFF = paths.dconfDiff;

        # Set the location of the files used for nx-rebuild
        NX_PRE_REBUILD = paths.preRebuild;
        NX_POST_REBUILD = paths.postRebuild;

        # Set the location of the todo doc
        NX_TODO = dotsTodo;
      };
    in
    {
      # Set environment variables
      environment.variables = variables;

      # Install comma via nix-index so that it's wrapped correctly
      # Comma can run non-installed packages by prepending the command with a ','
      programs.nix-index-database.comma.enable = true;
      # But disable nix-index hook into command-not-found because I don't like its delay
      programs.nix-index.enable = false;

      # Add some post-build actions
      my.scripts.nx.rebuild.postRebuildActions = mkIf (paths.dconfDiff != null) ''
        # Save current dconf settings (for nx-dconf-diff)
        echo "Dumping dconf"
        mkdir --parents "$(dirname "${paths.dconfDiff}")" && touch "${paths.dconfDiff}"
        dconf dump / >"${paths.dconfDiff}"
      '';

      # Add nx scripts and other packages
      environment.systemPackages = with pkgs; [
        # Nix helper utilities
        nh
        nurl
        nix-init

        (pkgs.writeScriptWithDeps {
          name = "nx-cleanup";
          file = ./scripts/nx-cleanup.sh;
          deps = [ nh ];
          replaceVariables = variables;
        })

        (pkgs.writeScriptWithDeps {
          name = "nx-rebuild";
          file = ./scripts/nx-rebuild.sh;
          deps = [
            dconf
            git
            nixfmt-rfc-style
            nh
          ];
          replaceVariables = variables;
        })

        (pkgs.writeScriptWithDeps {
          name = "nx-code";
          file = ./scripts/nx-code.sh;
          replaceVariables = variables;
        })

        (pkgs.writeScriptWithDeps {
          name = "nx-template";
          file = ./scripts/nx-template.sh;
          replaceVariables = variables;
        })

        (pkgs.writeScriptWithDeps {
          name = "nx-todo";
          file = ./scripts/nx-todo.sh;
          replaceVariables = variables;
        })

        (pkgs.writeScriptWithDeps {
          name = "nx-dconf-diff";
          file = ./scripts/nx-dconf-diff.sh;
          deps = [
            dconf
            difftastic
          ];
          replaceVariables = variables;
        })
      ];

      my.keybinds = {
        "Open nx-code" = {
          binding = "<Super>F9";
          command = "nx-code";
        };

        "Open nx-todo" = {
          binding = "<Super>F10";
          command = "nx-todo";
        };
      };

      system.userActivationScripts = {
        # Set up pre- and post actions for nx-rebuild
        writePreRebuild = writeFile {
          path = paths.preRebuild;
          text = cfg.rebuild.preRebuildActions;
          force = true;
        };

        writePostRebuild = writeFile {
          path = paths.postRebuild;
          text = cfg.rebuild.postRebuildActions;
          force = true;
        };
      };

      home-manager.users.${user} = {
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
