{ nixosModulesOld, ... }:

{
  imports = with nixosModulesOld; [
    desktop.gnome.extensions.ddterm
  ];
}
