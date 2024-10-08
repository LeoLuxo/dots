{
  catppuccin,
  user,
  ...
}:

{
  home-manager.users.${user} = {
    imports = [
      catppuccin.homeManagerModules.catppuccin
    ];

    # Choose flavor
    catppuccin.flavor = "mocha";

    # Enable the theme for all compatible apps
    catppuccin.enable = true;
  };
}
