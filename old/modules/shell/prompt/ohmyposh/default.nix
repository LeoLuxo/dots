{
  constants,
  ...
}:

{
  home-manager.users.${config.my.user.name} = {
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
