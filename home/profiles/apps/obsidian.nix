{
  lib,
  pkgs,
  homeProfiles,
  ...
}:

{
  imports = [
    # Require fonts
    homeProfiles.common.fonts
  ];

  home.sessionVariables = {
    APP_NOTES = lib.mkDefault "obsidian";
  };

  my.packages = with pkgs; [
    obsidian
  ];
}
