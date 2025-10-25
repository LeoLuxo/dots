{ lib2, pkgs, ... }:

let
  inherit (lib2.hm) mkHomeSymlink;
in
{
  hm = {
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
  };

  environment.systemPackages = [ pkgs.custom.yuzu ];
}
