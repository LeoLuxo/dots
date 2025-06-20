{
  constants,
  pkgs,
  ...
}:

let
  inherit (constants) user;
in

{
  home-manager.users.${user} =
    { config, ... }:
    {
      home.packages = [
        pkgs.joycond-cemuhook
      ];

    };

  services.joycond.enable = true;
}
