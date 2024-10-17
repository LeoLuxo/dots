{
  lib,
  pkgs,
  user,
  directories,
  ...
}:

# Convert the .heic wallpapers to wallutils' stw
# using a derivation
let
  wallpaperBuild = pkgs.callPackage (
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
          
          # Extract the individual images from the .heic as .jpg
          magick "$filename" "$out/$name/%02d.jpg"
          
          # Convert the .heic timing info to .stw and fix the hardcoded path in the .stw
          heic2stw "$filename" > "$out/$name/$name.stw"
          sed -i "s#/usr/share/backgrounds/#$out/#g" "$out/$name/$name.stw"
        done
      '';
    }
  ) { };

  wallpapers = lib.mapAttrs (n: v: "${wallpaperBuild}/${n}/${n}.stw") (
    lib.filterAttrs (n: v: v == "directory") (builtins.readDir wallpaperBuild)
  );
in
{
  imports = [
    directories.modules.wallutils
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wallutils
    ];

    services.wallutils = {
      enable = true;

      timed = {
        enable = true;
        theme = (lib.traceValSeq wallpapers)."Outset Island";
        mode = "center";
      };
    };
  };
}
