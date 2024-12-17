{ extra-libs, ... }:

let
  inherit (extra-libs) findFiles;
in

{
  modules = findFiles {
    dir = ./modules;
    extensions = [ "nix" ];
    defaultFiles = [ "default.nix" ];
  };

  hosts = findFiles {
    dir = ./hosts;
    extensions = [ "nix" ];
    defaultFiles = [ "default.nix" ];
  };

  images = findFiles {
    dir = ./assets;
    extensions = [
      "png"
      "jpg"
      "jpeg"
      "gif"
      "svg"
      "heic"
    ];
  };

  wallpapers = findFiles {
    dir = ./assets/wallpapers;
    extensions = [
      "png"
      "jpg"
      "jpeg"
      "heic"
    ];
    defaultFiles = [ "wallpaper.stw" ];
  };

  icons = findFiles {
    dir = ./assets/icons;
    extensions = [
      "ico"
      "icns"
    ];
  };
}
