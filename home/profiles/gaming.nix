{ inputs, pkgs, ... }:
{
  home.packages = [
    # Switch emulator
    inputs.self.packages.yuzu
    pkgs.ryubing # fork of ryujinx
    # inputs.self.packages.sudachi

  ];

  xdg.dataFile."sudachi".target = "/stuff/games/emu/switch/yuzu";
  xdg.dataFile."yuzu".target = "/stuff/games/emu/switch/yuzu";

  xdg.configFile."Ryujinx".target = "/stuff/games/emu/switch/ryujinx";

  xdg.configFile."steam-rom-manager/userData".target = "/stuff/games/emu/steamRomManager/userData";
}
