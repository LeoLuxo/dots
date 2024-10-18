{
  lib,
  pkgs,
  directories,
  ...
}:

# Convert the .heic wallpapers to wallutils' stw
# using a derivation
let
  wallpaperBuild =
    file:
    pkgs.callPackage (
      {
        lib,
        stdenv,
        wallutils,
        imagemagick,
      }:
      stdenv.mkDerivation {
        name = "nx-timed-wallpapers";
        src = file;

        nativeBuildInputs = [
          wallutils
          imagemagick
        ];

        buildPhase = ''
          filename="${file}"
          name="''${filename%.*}"
          mkdir -p "$out/$name"

          # Extract the individual images from the .heic as .jpg
          magick "$filename" "$out/%02d.jpg"

          # Convert the .heic timing info to .stw and fix the hardcoded path in the .stw
          heic2stw "$filename" > "$out/$name.stw"
          sed -i "s#/usr/share/backgrounds/#$out/#g" "$out/$name.stw"
        '';
      }
    ) { };

  # Cleanup the wallpapers into an attribute set
  wallpapers = lib.mapAttrs (n: v: "${wallpaperBuild}/${n}/${n}.stw") (
    lib.filterAttrs (n: v: v == "directory") (builtins.readDir wallpaperBuild)
  );
in
{
  # Disable default gnome wallpapers
  environment.gnome.excludePackages = [ pkgs.gnome-backgrounds ];

  imports = [
    directories.modules.wallutils
  ];

  services.wallutils = {
    enable = true;

    timed = {
      enable = true;
      theme = wallpapers."Forest";
    };
  };
}
