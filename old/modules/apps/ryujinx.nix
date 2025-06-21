{
  constants,
  config,
  pkgs,
  nixosModulesOld,
  ...
}:

{
  imports = [ nixosModulesOld.apps.joycons ];

  ext.packages = [
    pkgs.ryubing
  ];

  home-manager.users.${config.ext.system.user.name} =
    { config, ... }:
    {
      xdg.configFile."Ryujinx".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/switch/data/ryujinx";
    };
}
