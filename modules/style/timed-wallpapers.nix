{
  lib,
  pkgs,
  user,
  directories,
  ...
}:

# Convert the .heic wallpapers to wallutils' swf
# using a derivation
let
  wallpapers = pkgs.callPackage (
    {
      lib,
      stdenv,
      wallutils,
      imagemagick,
    }:
    stdenv.mkDerivation {
      name = "nx-timed-wallpapers";
      src = directories.images.timed-wallpapers._dir;

      nativeBuildInputs = [
        wallutils
        imagemagick
      ];

      buildPhase = ''
        for filename in *.heic; do
          name="''${filename%.*}"
          
          mkdir -p "$out/$name"
          magick "$filename" "$out/$name/%02d.jpg"
          
        done
      '';
    }
  ) { };
in
{
  imports = [
    directories.modules.wallutils
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wallutils
      (builtins.trace "${wallpapers}" wallpapers)
    ];
  };

  services.wallutils = {
    enable = true;
  };

}
