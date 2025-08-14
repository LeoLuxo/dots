{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Require fonts
    ../../modules/fonts.nix
  ];

  my.defaultApps.notes = lib.mkDefault "obsidian";

  my.packages = with pkgs; [
    obsidian
  ];
}
