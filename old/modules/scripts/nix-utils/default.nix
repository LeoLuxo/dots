{
  pkgs,
  config,
  inputs,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) dotsRepoPath secretsPath;
  inherit (extraLib)
    mkGlobalKeybind
    mkShellHistoryAlias
    writeScriptWithDeps
    mkSubmodule
    mkEmptyLines
    replaceScriptVariables
    ;
in

{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index

    (mkGlobalKeybind {
      name = "Open nx-code";
      binding = "<Super>F9";
      command = "nx-code";
    })

    (mkGlobalKeybind {
      name = "Open nx-todo";
      binding = "<Super>F10";
      command = "nx-todo";
    })

    (mkShellHistoryAlias {
      name = ",,";
      command = { lastCommand }: '', ${lastCommand}'';
    })
  ];

  options.nx = {
    rebuild = mkSubmodule {
      preRebuildActions = mkEmptyLines;
      postRebuildActions = mkEmptyLines;
    };
  };

  config =
    let
      cfg = config.nx;
      variables = {
        # Set the location of the dots and secrets repos
        NX_DOTS = dotsRepoPath;
        NX_SECRETS = secretsPath;

        # Set the location of the file used for dconf-diff
        NX_DCONF_DIFF = "${config.my.system.user.home}/.nx/dconf_diff";

        # Set the location of the files used for nx-rebuild
        NX_PRE_REBUILD = "${config.my.system.user.home}/.nx/pre_rebuild.sh";
        NX_POST_REBUILD = "${config.my.system.user.home}/.nx/post_rebuild.sh";

        # Set the location of the todo doc
        NX_TODO = "/stuff/obsidian/Notes/NixOS Todo.md";
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
      nx.rebuild.postRebuildActions = replaceScriptVariables ''
        # Save current dconf settings (for nx-dconf-diff)
        echo "Dumping dconf"
        mkdir --parents "$(dirname "$NX_DCONF_DIFF")" && touch "$NX_DCONF_DIFF"
        dconf dump / >"$NX_DCONF_DIFF"
      '' variables;

      # Add nx scripts and other packages
      my.packages = with pkgs; [
        # Nix helper utilities
        nh
        nurl
        nix-init

        (writeScriptWithDeps {
          name = "nx-code";
          file = ./scripts/nx-code.sh;
          replaceVariables = variables;
        })

        (writeScriptWithDeps {
          name = "nx-todo";
          file = ./scripts/nx-todo.sh;
          replaceVariables = variables;
        })

        (writeScriptWithDeps {
          name = "nx-secret";
          file = ./scripts/nx-secret.sh;
          deps = [ nano ];
          replaceVariables = variables;
        })

        (writeScriptWithDeps {
          name = "nx-template";
          file = ./scripts/nx-template.sh;
          replaceVariables = variables;
        })

        (writeScriptWithDeps {
          name = "nx-cleanup";
          file = ./scripts/nx-cleanup.sh;
          deps = [ nh ];
          replaceVariables = variables;
        })

        (writeScriptWithDeps {
          name = "nx-dconf-diff";
          file = ./scripts/nx-dconf-diff.sh;
          deps = [
            dconf
            difftastic
          ];
          replaceVariables = variables;
        })

        (writeScriptWithDeps {
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
      ];

      home-manager.users.${config.my.system.user.name} = {
        # Set up pre- and post actions for nx-rebuild
        home.file.".nx/pre_rebuild.sh".text = cfg.rebuild.preRebuildActions;
        home.file.".nx/post_rebuild.sh".text = cfg.rebuild.postRebuildActions;

        # Add aliases
        home.shellAliases = {
          nx-cd = "cd $NX_DOTS";
          nxcd = "nx-cd";

          nxr = "nx-rebuild";

          nx-edit = "nx-code";
          # nx-search = "nh search --limit 4";
        };
      };
    };

}
