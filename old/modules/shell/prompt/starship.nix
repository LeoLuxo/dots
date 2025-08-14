{
  config,
  ...
}:

{
  home-manager.users.${config.my.user.name} = {
    programs.starship = {
      enable = true;

      # enableTransience = true;
    };
  };
}
