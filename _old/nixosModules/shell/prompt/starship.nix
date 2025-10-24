{
  config,
  user,
  ...
}:

{
  home-manager.users.${user} = {
    programs.starship = {
      enable = true;

      # enableTransience = true;
    };
  };
}
