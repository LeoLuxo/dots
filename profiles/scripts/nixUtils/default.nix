{
  pkgs,
  inputs,
  lib,
  lib2,
  config,
  user,
  ...
}:

let
  preRebuildFile = ".nx/pre_rebuild.sh";
  postRebuildFile = ".nx/post_rebuild.sh";
in
{
  imports = [
    inputs.nix-index-database.nixosModules.nix-index

    (lib2.nixos.mkShellHistoryAlias {
      name = ",,";
      command = { lastCommand }: '', ${lastCommand}'';
    })
  ];

  options.nx = {
    preRebuildActions = lib.options.mkOption {
      type = lib.types.lines;
      default = "";
    };

    postRebuildActions = lib.options.mkOption {
      type = lib.types.lines;
      default = "";
    };
  };

  config =
    let
      variables = {
        # Set the location of the files used for nx-rebuild
        NX_PRE_REBUILD = "/home/${user}/${preRebuildFile}";
        NX_POST_REBUILD = "/home/${user}/${postRebuildFile}";
      };
    in
    {
      # Install comma via nix-index so that it's wrapped correctly
      # Comma can run non-installed packages by prepending the command with a ','
      programs.nix-index-database.comma.enable = true;
      # But disable nix-index hook into command-not-found because I don't like its delay
      programs.nix-index.enable = false;

      hm = {
        # Set environment variables
        home.sessionVariables = variables;

        # Set up pre- and post actions for nx-rebuild
        home.file.${preRebuildFile} = {
          text = config.nx.preRebuildActions;
          force = true;
        };
        home.file.${postRebuildFile} = {
          text = config.nx.postRebuildActions;
          force = true;
        };

        # Add aliases
        home.shellAliases = {
          nxr = "nx-rebuild";

          nx-search = "nh search --limit 4";
        };

        # Add nx scripts and other packages
        home.packages = with pkgs; [
          # Nix helper utilities
          nh
          nurl
          nix-init

          (pkgs.writeScriptWithDeps {
            name = "nx-cleanup";
            file = ./nx-cleanup.sh;
            deps = [ nh ];
            replaceVariables = variables;
          })

          (pkgs.writeScriptWithDeps {
            name = "nx-rebuild";
            file = ./nx-rebuild.sh;
            deps = [
              dconf
              git
              nixfmt-rfc-style
              nh
            ];
            replaceVariables = variables;
          })
        ];
      };
    };
}
