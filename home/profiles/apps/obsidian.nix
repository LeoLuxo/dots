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

  home.packages = with pkgs; [
    obsidian
  ];
}
