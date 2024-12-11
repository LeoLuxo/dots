{
  pkgs,
  directories,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  # Disable default gnome wallpapers
  environment.gnome.excludePackages = [ pkgs.gnome-backgrounds ];

  home-manager.users.${user} = {
    xdg = {
      enable = true;

      # Symlink all static wallpapers into the gnome wallpaper directory
      # ~/.local/share/backgrounds
      dataFile."backgrounds" = {
        source = directories.images.static-wallpapers._dir;
        # recursive = true;
      };
    };
  };
}
