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

  ext.packages = with pkgs; [
    obsidian
  ];
}
