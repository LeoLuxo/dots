{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  home-manager.users.${user} = {
    home.packages = [
      pkgs.beets
    ];
  };

  environment.variables = {
    BEETSDIR = ./beets-config.yaml;
  };
}
