{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      upscaler = prev.upscaler.overrideAttrs (oldAttrs: {
        postInstall = ''
          ${oldAttrs.postInstall or ""}
          # Fixes Error 71 (Protocol error) dispatching to Wayland display.
          wrapProgram $out/bin/upscaler --set GDK_BACKEND x11
        '';
      });
    })
  ];

  environment.systemPackages = [
    pkgs.upscaler # An application that enhances image resolution by upscaling photos using advanced processing (designed in the GNOME spirit).
  ];
}
