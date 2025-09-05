{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Triple buffering fork thing, currently broken
    # ./tripleBuffering.nix

    # Default gnome apps
    ./defaultApps.nix
  ];

  environment.systemPackages = [
    # HEIC support
    pkgs.libheif
    pkgs.libheif.out

    # Needs to be installed system-wide for everything to work properly
    pkgs.gnomeExtensions.just-perfection
  ];

  # Something something HEIC?
  environment.pathsToLink = [ "share/thumbnailers" ];

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # (even with autologin disabled I need this otherwise nixos-rebuild crashes gnome??)
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Enable the GNOME Desktop Environment.
  services.xserver = {
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome = {
      enable = true;

      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['variable-refresh-rate']
      '';
    };
  };

  # Enable the gnome keyring
  services.gnome.gnome-keyring.enable = true;

  # Fixes "Your GStreamer installation is missing a plug-in." when trying to view audio/video properties
  environment.sessionVariables.GST_PLUGIN_SYSTEM_PATH_1_0 =
    lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0"
      [
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-plugins-ugly
        pkgs.gst_all_1.gst-plugins-base
      ];
}
