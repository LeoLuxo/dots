{
  pkgs,
  nix-index-database,
  constants,
  directories,
  extra-libs,
  ...
}:

let
  inherit (constants)
    user
    userHome
    dotsRepoPath
    secretsRepoPath
    ;
  inherit (directories) scriptBin;
  inherit (extra-libs) mkGlobalKeybind mkShellHistoryAlias writeScriptWithDeps;
in

{
  imports = [
    nix-index-database.nixosModules.nix-index

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

  # Install comma via nix-index so that it's wrapped correctly
  # Comma can run non-installed packages by prepending the command with a ','
  programs.nix-index-database.comma.enable = true;
  # But disable nix-index hook into command-not-found because I don't like it's delay
  programs.nix-index.enable = false;

  environment.variables = {
    # Set the location of the dots and secrets repos
    NX_DOTS = dotsRepoPath;
    NX_SECRETS = secretsRepoPath;

    # Set the location of the file used for dconf-diff
    DCONF_DIFF = "${userHome}/.dconf_activation";

    # Set the location of the todo doc
    NX_TODO = "/stuff/Obsidian/Notes/NixOS Todo.md";
  };

  home-manager.users.${user} = {
    # Add scripts from the nx directory and other packages
    home.packages = with pkgs; [
      # Nix helper utilities
      nh
      nurl
      nix-init

      (writeScriptWithDeps {
        name = "nx-code";
        file = ./scripts/nx-code.sh;
      })

      (writeScriptWithDeps {
        name = "nx-todo";
        file = ./scripts/nx-todo.sh;
      })

      (writeScriptWithDeps {
        name = "nx-template";
        file = ./scripts/nx-template.sh;
      })

      (writeScriptWithDeps {
        name = "nx-cleanup";
        file = ./scripts/nx-cleanup.sh;
        deps = [ nh ];
      })

      (writeScriptWithDeps {
        name = "nx-dconf-diff";
        file = ./scripts/nx-dconf-diff.sh;
        deps = [
          dconf
          difftastic
        ];
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
      })
    ];

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
