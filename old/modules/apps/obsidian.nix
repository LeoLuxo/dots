{
  lib,
  pkgs,
  nixosModulesOld,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = with nixosModulesOld; [
    # Require fonts
    fonts
  ];

  defaults.apps.notes = lib.mkDefault "obsidian";

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
