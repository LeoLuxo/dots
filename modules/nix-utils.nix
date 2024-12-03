{
  pkgs,
  user,
  userHome,
  scriptBin,
  nixRepoPath,
  nix-index-database,
  ...
}:
{
  imports = [
    nix-index-database.nixosModules.nix-index
  ];

  # Install comma via nix-index so that it's wrapped correctly
  # Comma can run non-installed packages by prepending the command with a ','
  programs.nix-index-database.comma.enable = true;

  environment.variables = {
    # Set the location of the config repo
    NX_REPO = nixRepoPath;

    # Set the location of the file used for dconf-diff
    DCONF_DIFF = "${userHome}/.dconf_activation";

    # Set the location of the todo doc
    NX_TODO = "/stuff/obsidian/Notes/NixOS Todo.md";
  };

  home-manager.users.${user} = {
    # Add scripts from the nx directory
    home.packages = with pkgs; [

      (scriptBin.nx.nx-cleanup { })

      (scriptBin.nx.nx-code { })

      (scriptBin.nx.nx-dconf-diff {
        deps = [
          dconf
          difftastic
        ];
      })

      (scriptBin.nx.nx-rebuild {
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
      nx-cd = "cd $NX_REPO";
      nxcd = "nx-cd";
    };
  };

}
