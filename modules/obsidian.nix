{
  pkgs,
  user,
  moduleSet,
  ...
}:

{
  # Require fonts
  imports = with moduleSet; [ fonts ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      obsidian
    ];
  };
}
