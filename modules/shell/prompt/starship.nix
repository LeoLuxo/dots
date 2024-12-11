{
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  home-manager.users.${user} = {
    programs.starship = {
      enable = true;

      # enableTransience = true;
    };
  };
}
