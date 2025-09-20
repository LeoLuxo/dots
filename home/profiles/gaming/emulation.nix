{
  inputs,
  pkgs,
  lib2,
  homeProfiles,
  ...
}:

let
  inherit (lib2.hm) mkSymlink;
in
{
  imports = [
    homeProfiles.gaming.base

    (mkSymlink {
      xdgDir = "data";
      target = "sudachi";
      destination = "/stuff/games/emu/switch/yuzu";
    })

    (mkSymlink {
      xdgDir = "data";
      target = "yuzu";
      destination = "/stuff/games/emu/switch/yuzu";
    })

    (mkSymlink {
      xdgDir = "config";
      target = "Ryujinx";
      destination = "/stuff/games/emu/switch/ryujinx";
    })

    (mkSymlink {
      xdgDir = "config";
      target = "steam-rom-manager/userData";
      destination = "/stuff/games/emu/steamRomManager/userData";
    })
  ];

  home.packages = [
    # Emulators
    inputs.self.packages.yuzu # Switch
    pkgs.ryubing # Switch (fork of ryujinx)
    pkgs.snes9x # SNES
    pkgs.snes9x-gtk # SNES
    pkgs.melonDS # Nintendo DS

    # inputs.self.packages.sudachi # Switch (fork of yuzu)
    # pkgs.higan # NES, SNES, GB, GBC, GBA, ...

    # To manage emulators & games
    # pkgs.lutris
    pkgs.steam-rom-manager
  ];
}
