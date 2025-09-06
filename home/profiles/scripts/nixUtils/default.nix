{
  pkgs,
  inputs,
  lib,
  lib2,
  config,
  ...
}:

{
  imports = [
    inputs.nix-index-database.homeModules.nix-index

    (lib2.hm.mkShellHistoryAlias {
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
        NX_PRE_REBUILD = "${config.home.homeDirectory}/.nx/pre_rebuild.sh";
        NX_POST_REBUILD = "${config.home.homeDirectory}/.nx/post_rebuild.sh";
      };
    in
    {
      # Set environment variables
      home.sessionVariables = variables;

      # Install comma via nix-index so that it's wrapped correctly
      # Comma can run non-installed packages by prepending the command with a ','
      programs.nix-index-database.comma.enable = true;
      # But disable nix-index hook into command-not-found because I don't like its delay
      programs.nix-index.enable = false;

      # Add some post-build actions
      nx.postRebuildActions = lib2.replaceScriptVariables ''
        # Save current dconf settings (for nx-dconf-diff)
        echo "Dumping dconf"
        mkdir --parents "$(dirname "$NX_DCONF_DIFF")" && touch "$NX_DCONF_DIFF"
        dconf dump / >"$NX_DCONF_DIFF"
      '' variables;

      # Set up pre- and post actions for nx-rebuild
      home.file.".nx/pre_rebuild.sh".text = config.nx.preRebuildActions;
      home.file.".nx/post_rebuild.sh".text = config.nx.postRebuildActions;

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
      ];
    };

}
