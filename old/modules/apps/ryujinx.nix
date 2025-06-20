{
  constants,
  pkgs,
  nixosModules,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = [ nixosModules.apps.joycons ];

  home-manager.users.${user} =
    { config, ... }:
    {
      home.packages = [
        pkgs.ryubing
      ];

      xdg.configFile."Ryujinx".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/switch/data/ryujinx";
    };
}
