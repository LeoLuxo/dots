{
  pkgs,
  user,
  scriptBin,
  ...
}:
{
  programs.dconf.enable = true;

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      (scriptBin.dconf-diff {
        deps = [
          difftastic
          dconf
        ];
        shell = true;
      })
    ];
  };

  system.userActivationScripts."dconf-diff".text = ''
    dconf dump / > ~/.dconf_activation
  '';
}
