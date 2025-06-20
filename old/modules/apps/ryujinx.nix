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

  ext.packages = [
    pkgs.ryubing
  ];

  home-manager.users.${user} =
    { config, ... }:
    {
      xdg.configFile."Ryujinx".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/switch/data/ryujinx";
    };
}
