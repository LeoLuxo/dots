{ lib2, pkgs, ... }:

let
  inherit (lib2.nixos) mkHomeSymlink;
in
{
  imports = [
    (mkHomeSymlink {
      xdgDir = "data";
      target = "sudachi";
      destination = "/stuff/games/emu/switch/yuzu";
    })

    (mkHomeSymlink {
      xdgDir = "data";
      target = "yuzu";
      destination = "/stuff/games/emu/switch/yuzu";
    })

    (mkHomeSymlink {
      xdgDir = "config";
      target = "Ryujinx";
      destination = "/stuff/games/emu/switch/ryujinx";
    })

    (mkHomeSymlink {
      xdgDir = "data";
      target = "Cemu";
      destination = "/stuff/games/emu/wiiu/Cemu";
    })

    (mkHomeSymlink {
      xdgDir = "config";
      target = "steam-rom-manager/userData";
      destination = "/stuff/games/emu/steamRomManager/userData";
    })

    (mkHomeSymlink {
      xdgDir = "data";
      target = "ukmm";
      destination = "/stuff/games/emu/wiiu/ukmm";
    })
  ];

  # Don't work as home.packages for some reason???
  environment.systemPackages = [
    # Emulators
    pkgs.custom.yuzu # Switch
    pkgs.ryubing # Switch (fork of ryujinx)
    pkgs.cemu # Wii U
    pkgs.melonDS # Nintendo DS
    pkgs.snes9x # SNES
    pkgs.snes9x-gtk # SNES

    # Emulators (unused)
    # pkgs.custom.sudachi # Switch (fork of yuzu)
    # pkgs.higan # NES, SNES, GB, GBC, GBA, ...

    # To manage emulators & games
    # pkgs.lutris # Game library manager
    pkgs.steam-rom-manager # Add emulated games to steam
    pkgs.custom.ukmm # Breath of the Wild mod manager
    pkgs.custom.wiiuDownloader # Wii U dumps/games downloader
  ];

}
