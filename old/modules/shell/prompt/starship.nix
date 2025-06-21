{
  config,
  ...
}:

{
  home-manager.users.${config.my.system.user.name} = {
    programs.starship = {
      enable = true;

      # enableTransience = true;
    };
  };
}
