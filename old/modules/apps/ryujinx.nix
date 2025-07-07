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

  my.symlinks.xdgConfig."Ryujinx" = "/stuff/games/roms/switch/data/ryujinx";
  # home-manager.users.${config.my.user.name} =
  #   { config, ... }:
  #   {
  #     xdg.configFile."Ryujinx".source =
  #       config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/switch/data/ryujinx";
  #   };
}
