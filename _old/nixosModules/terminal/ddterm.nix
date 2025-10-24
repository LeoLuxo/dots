{ nixosModules, user, ... }:

{
  imports = with nixosModules; [
    desktop.gnome.extensions.ddterm
  ];
}
