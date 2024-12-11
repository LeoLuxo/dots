{
  pkgs,
  directories,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  # Require fonts
  imports = with directories.modules; [
    style.fonts
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
