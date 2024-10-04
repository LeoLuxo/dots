{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.systemPackages = with pkgs; [
    # Adds AppIndicator, KStatusNotifierItem and legacy Tray icons support to the Shell
    # (Because gnome by default doesn't support tray icons)
    gnomeExtensions.appindicator
  ];
}
