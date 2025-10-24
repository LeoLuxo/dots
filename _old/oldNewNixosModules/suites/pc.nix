{
  lib,
  config,
  pkgs,
  lib2,
  user,
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
        locale = {
          enable = true;
        };
      };

      desktop = {
        defaultAppsShortcuts = {
          enable = true;
        };
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
