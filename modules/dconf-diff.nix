{
  user,
  scriptBin,
  ...
}:
{
  programs.dconf.enable = true;

  home-manager.users.${user} = {
    home.packages = [ scriptBin.dconf-diff ];
  };

  system.userActivationScripts."dconf-diff".text = ''
    dconf dump > ~/.dconf_activation
  '';

}
