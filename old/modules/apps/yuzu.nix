{
  constants,
  config,
  pkgs,
  nixosModulesOld,
  ...
}:

let
  package =
    {
      fetchurl,
      appimageTools,
      ...
    }:
    let
      pname = "yuzu";
      version = "EA-4176";

      src = fetchurl {
        url = "https://archive.org/download/citra-qt-and-yuzu-EA/Linux-Yuzu-EA-4176.AppImage";
        sha256 = "sha256-bUTVL8br2POy5HB1FszlNQNChdRWcwIlG6/RCceXIlg=";
      };

      appimageContents = appimageTools.extract {
        inherit pname version src;
      };

      desktopFileName = "org.yuzu_emu.yuzu";
    in
    appimageTools.wrapAppImage {
      inherit pname version;
      src = appimageContents;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/${desktopFileName}.desktop -t $out/share/applications
        cp -r ${appimageContents}/usr/share/icons $out/share
      '';
    };
in
{
  imports = [ nixosModulesOld.apps.joycons ];

  my.packages = [
    (pkgs.callPackage package { })
  ];
}
