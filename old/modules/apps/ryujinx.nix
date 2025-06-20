{
  constants,
  pkgs,
  nixosModulesOld,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = [ nixosModulesOld.apps.joycons ];

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
