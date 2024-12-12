{
  lib,
  stdenv,
  wallutils,
  imagemagick,
  file,
}:

let
  filename = builtins.baseNameOf file;
in
stdenv.mkDerivation (finalAttrs: {
  name = lib.strings.sanitizeDerivationName "heic-converted-wallpaper-${filename}";
  src = file;

  nativeBuildInputs = [
    wallutils
    imagemagick
  ];

  # By default since src is a file, nix will try to unpack it
  dontUnpack = true;

  buildPhase = ''
    mkdir -p "$out"

    # Extract the individual images from the .heic as .jpg
    magick "$src" "$out/%02d.jpg"

    # Convert the .heic timing info to .stw and fix the hardcoded path in the .stw
    heic2stw "$src" > "$out/wallpaper.stw"
    sed -i "s&^format:.*&format: %s.jpg&" "$out/wallpaper.stw"
  '';
})
