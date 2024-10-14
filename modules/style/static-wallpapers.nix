{
  lib,
  user,
  directories,
  ...
}:

{

  # On activation move existing files by appending the given file extension rather than exiting with an error.
  home-manager.backupFileExtension = "bak";

  home-manager.users.${user} = {
    xdg = {
      enable = true;

      # Symlink all static wallpapers into the gnome wallpaper directory
      # ~/.local/share/backgrounds
      dataFile."backgrounds".source = directories.images.wallpapers._dir;
    };
  };
}
