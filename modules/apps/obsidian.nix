{
  lib,
  pkgs,
  directories,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = with directories.modules; [
    # Require fonts
    fonts
  ];

  defaultPrograms.notes = lib.mkDefault "obsidian";

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}