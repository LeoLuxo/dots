{ nixosModules, ... }:

{
  imports = with nixosModules; [
    desktop.gnome.extensions.ddterm
  ];
}
