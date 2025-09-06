{
  inputs,
  pkgs,
  lib2,
  ...
}:

let
  inherit (lib2) mkSymlink;
in
{
  imports = [
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
    # Switch emulator
    inputs.self.packages.yuzu
    pkgs.ryubing # fork of ryujinx
    # inputs.self.packages.sudachi

    pkgs.steam-rom-manager
  ];
}
