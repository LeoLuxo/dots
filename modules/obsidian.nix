{
  pkgs,
  user,
  directories,
  ...
}:

{
  # Require fonts
  imports = with directories.modules; [
    fonts
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
