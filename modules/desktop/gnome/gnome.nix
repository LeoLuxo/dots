{
  lib,
  directories,
  ...
}:

{
  imports = with directories.modules; [
    ../options.nix

    # Triple buffering fork thing
    ./triple-buffering.nix

    # Default gnome apps 
    ./default-apps.nix

    # All the dconf settings
    ./settings.nix

    # Base extensions that should be included by default
    desktop.gnome.extensions.just-perfection
    desktop.gnome.extensions.removable-drive-menu
    desktop.gnome.extensions.appindicator
    desktop.gnome.extensions.bluetooth-quick-connect
  ];

  desktop.name = "gnome";

  # Enable and configure the X11 windowing system.
  services.xserver = {
    enable = true;

    # Enable the GNOME Desktop Environment.
    displayManager.gdm = {
      enable = true;
      # UNder wayland
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  defaultPrograms.backupTerminal = lib.mkDefault "kgx";
  defaultPrograms.terminal = lib.mkOverride 1050 "kgx";

}
