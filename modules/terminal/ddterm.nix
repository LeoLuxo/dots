{ directories, ... }:

{
  imports = with directories.modules; [ gnome.extensions.ddterm ];
}
