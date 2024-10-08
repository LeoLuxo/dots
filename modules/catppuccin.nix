{
  catppuccin,
  user,
  ...
}:

{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];

  # Choose flavor
  catppuccin.flavor = "mocha";
  catppuccin.accent = "blue";

  # Enable the theme for all compatible apps
  catppuccin.enable = true;

  boot.plymouth.catppuccin.enable = true;
}
