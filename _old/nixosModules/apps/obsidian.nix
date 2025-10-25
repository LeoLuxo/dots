{
  lib,
  pkgs,
  user,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    obsidian
  ];

  home-manager.users.${user}.home.sessionVariables = {
    APP_NOTES = lib.mkDefault "obsidian";
  };
}
