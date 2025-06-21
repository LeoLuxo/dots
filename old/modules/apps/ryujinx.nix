{
  constants,
  config,
  pkgs,
  nixosModulesOld,
  ...
}:

{
  imports = [ nixosModulesOld.apps.joycons ];

  my.packages = [
    pkgs.ryubing
  ];

  home-manager.users.${config.my.system.user.name} =
    { config, ... }:
    {
      xdg.configFile."Ryujinx".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/switch/data/ryujinx";
    };
}
