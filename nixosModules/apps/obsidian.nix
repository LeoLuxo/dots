{
  lib,
  pkgs,
  nixosModules,
  ...
}:

{
  imports = with nixosModules; [
    # Require fonts
    fonts
  ];

  my.defaultApps.notes = lib.mkDefault "obsidian";

  my.packages = with pkgs; [
    obsidian
  ];
}
