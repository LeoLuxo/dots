{
  lib,
  config,
  pkgs,
  lib2,
  ...
}:

let
  inherit (lib) types;
  inherit (lib2) enabled;
  inherit (lib.options) mkOption;

  cfg = config.my.suites.pc;
in
{
  options.my.suites.pc = {
    enable = lib.mkEnableOption "the personal computer suite";

    username = mkOption {
      description = "The username of the single user of the system.";
      type = types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    my = {
      system = {
        user.name = cfg.username;
        boot = {
          enable = true;
        };
        locale = {
          enable = true;
        };
        printing = {
          enable = true;
        };
      };

      desktop = {
        defaultAppsShortcuts = {
          enable = true;
        };
        # fonts = {enable = true;};
      };
      scripts = {
        nx = {
          enable = true;

          # Auto-update wallpaper repo
          # rebuild.preRebuildActions = ''
          #   echo "Updating wallpaper flake"
          #   nix flake update wallpapers --allow-dirty
          #   git add flake.lock
          # '';
        };

        # terminalUtils = {enable = true;};

        # snip = {enable = true;};
        # clipboard = {enable = true;};
      };
    };
  };
}
