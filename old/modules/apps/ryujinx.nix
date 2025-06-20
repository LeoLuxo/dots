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
        pkgs.ryubing
      ];

      xdg.configFile."Ryujinx".source =
        config.lib.file.mkOutOfStoreSymlink "/stuff/games/roms/switch/data/ryujinx";
    };
}
