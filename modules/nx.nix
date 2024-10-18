{
  pkgs,
  user,
  scriptBin,
  ...
}:
{
  environment.variables = {
    # Set the location of the config repo
    NX_REPO = "/etc/nixos/dots";

    # Set the location of the file used for dconf-diff
    DCONF_DIFF = "/home/${user}/.dconf_activation";
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
        ];
      })
    ];
  };

}
