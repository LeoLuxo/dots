{
  stylix,
  directories,
  ...
}:

{
  imports = [
    stylix.nixosModules.stylix
  ];

  stylix.enable = true;
  stylix.image = directories.images."wallpaper-sky";
  stylix.polarity = "dark";

}
