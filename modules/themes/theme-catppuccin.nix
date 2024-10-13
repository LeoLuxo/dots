{
  pkgs,
  stylix,
  directories,
  ...
}:

{
  imports = [
    stylix.nixosModules.stylix
  ];

  stylix.enable = true;

  stylix.image = directories.images."wallpaper-nixos";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
  stylix.polarity = "dark";

}
