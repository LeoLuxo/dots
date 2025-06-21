{
  config,
  ...
}:

{
  home-manager.users.${config.ext.system.user.name} = {
    programs.starship = {
      enable = true;

      # enableTransience = true;
    };
  };
}
