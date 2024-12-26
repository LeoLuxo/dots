{ directories, ... }:

{
  imports = with directories.modules; [
    desktop.gnome.extensions.ddterm
  ];
}
