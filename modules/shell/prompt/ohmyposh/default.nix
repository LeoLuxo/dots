{
  user,
  ...
}:
{
  home-manager.users.${user} = {
    programs.oh-my-posh = {
      enable = true;
      settings = import ./theme.nix;

      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
  };
}
