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

  defaults.apps.notes = lib.mkDefault "obsidian";

  my.packages = with pkgs; [
    obsidian
  ];
}
