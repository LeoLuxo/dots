{ pkgs, ... }:

# An AI image upscaler

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
    pkgs.upscaler
  ];
}
