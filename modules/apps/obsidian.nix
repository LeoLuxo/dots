{
  lib,
  pkgs,
  nixosModules,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = with nixosModules; [
    # Require fonts
    fonts
  ];

  defaults.apps.notes = lib.mkDefault "obsidian";

  home-manager.users.${constants.user} = {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
