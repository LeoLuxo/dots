{
  lib,
  pkgs,
  nixosModulesOld,
  ...
}:

{
  imports = with nixosModulesOld; [
    # Require fonts
    fonts
  ];

  my.desktop.defaultApps.notes = lib.mkDefault "obsidian";

  my.packages = with pkgs; [
    obsidian
  ];
}
