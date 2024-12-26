{
  config,
  lib,
  directories,
  extra-libs,
  ...
}:

let
  inherit (extra-libs)
    mkBoolDefaultTrue
    mkSubmodule
    mkBoolDefaultFalse
    ;
in

{
  imports = with directories.modules; [
    # Triple buffering fork thing
    ./triple-buffering.nix

    # Default gnome apps 
    ./default-apps.nix

    # All the dconf settings
    ./settings.nix

    # Base extensions that should be included by default
    gnome.extensions.just-perfection
    gnome.extensions.removable-drive-menu
    gnome.extensions.appindicator
    gnome.extensions.bluetooth-quick-connect
  ];

  options.gnome = with lib; {
    enable = mkBoolDefaultTrue;

    power = mkSubmodule {
      button-action = mkOption {
        type = types.enum [
          "power off"
          "suspend"
          "hibernate"
          "nothing"
        ];
        default = "power off";
      };

      confirm-shutdown = mkBoolDefaultTrue;

      screen-idle = mkSubmodule {
        enable = mkBoolDefaultTrue;

        delay = mkOption {
          type = types.ints.unsigned;
          default = 300;
        };
      };

      suspend-idle = mkSubmodule {
        enable = mkBoolDefaultFalse;

        delay = mkOption {
          type = types.ints.unsigned;
          default = 1800;
        };
      };
    };
  };

  config =
    let
      inherit (lib) modules;
      cfg = config.gnome;
    in
    modules.mkIf cfg.enable {
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
    };
}
