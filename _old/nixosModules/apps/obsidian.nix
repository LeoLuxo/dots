{
  lib,
  pkgs,
  ...
}:

{
  my.defaultApps.notes = lib.mkDefault "obsidian";

  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
