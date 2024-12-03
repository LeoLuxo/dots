{
  pkgs,
  user,
  scriptBin,
  nixRepoPath,
  ...
}:
{
  environment.variables = {
    # Set the location of the config repo
    NX_REPO = nixRepoPath;

    # Set the location of the file used for dconf-diff
    DCONF_DIFF = "/home/${user}/.dconf_activation";

    # Set the location of the todo doc
    NX_TODO = "/stuff/obsidian/Notes/NixOS Todo.md";
  };

  home-manager.users.${user} = {
    # Add scripts from the nx directory
    home.packages = with pkgs; [

      # Comma can run non-installed packages by prepending the command with a ','
      comma

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
