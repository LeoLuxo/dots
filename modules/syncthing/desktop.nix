{
  stdenv,
  makeDesktopItem,
  copyDesktopItems,
  directories,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "syncthing-desktop-icon";
  version = "0.0.0";

  dontUnpack = true;

  # installPhase = ''
  #   mkdir -p $out

  #   install -Dm0644 "${directories.images.syncthing}" $out/share/icons/hicolor/2048x2048/apps/syncthing.png
  # '';

  nativeBuildInputs = [ copyDesktopItems ];

  desktopItems = (
    makeDesktopItem {
      name = "syncthing";
      desktopName = "Syncthing";
      exec = "firefox \"http://127.0.0.1:8384/\"";
      icon = "${directories.images.syncthing}";
      keywords = [
        "syncthing"
      ];
      categories = [
        "Network"
        "FileTransfer"
        "P2P"
      ];
    }
  );
})
