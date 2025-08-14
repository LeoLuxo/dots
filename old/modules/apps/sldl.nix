{
  pkgs,
  config,
  ...
}:

let
  package =
    {
      stdenv,
      lib,
      fetchzip,
      alsa-lib,
      openssl,
      zlib,
      pulseaudio,
      autoPatchelfHook,
    }:

    stdenv.mkDerivation rec {
      pname = "slsk-batchdl";
      version = "2.4.6";
      arch = "x64";

      src = fetchzip {
        url = "https://github.com/fiso64/slsk-batchdl/releases/download/v${version}/sldl_linux-${arch}.zip";
        hash = "sha256-KyprBbp9rNSmKzBG7IjR22osqtAxsEuVFZ7FUPhmprg=";
        stripRoot = false;
      };

      nativeBuildInputs = [
        autoPatchelfHook
      ];

      buildInputs = [
        alsa-lib
        openssl
        zlib
        pulseaudio
      ];

      # sourceRoot = ".";

      installPhase = ''
        runHook preInstall
        install -m755 -D sldl $out/bin/sldl
        runHook postInstall
      '';

      meta = with lib; {
        homepage = "https://github.com/fiso64/slsk-batchdl";
        description = "An automatic downloader for Soulseek built with Soulseek.NET. Accepts CSV files as well as Spotify and YouTube urls.";
        platforms = platforms.linux;
      };
    };
in

{
  my.packages = with pkgs; [
    (callPackage package { })
  ];
}
