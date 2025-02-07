{
  cfg,
  lib,
  pkgs,
  extraLib,
  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
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

    home-manager.users.${constants.user}.home.packages = [
      # An application that enhances image resolution by upscaling photos using advanced processing (designed in the GNOME spirit).
      pkgs.upscaler
    ];
  };
}
