{
  lib,
  config,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.my) enabled;
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
        boot = enabled;
        locale = enabled;
        printing = enabled;
      };

      desktop = {
        defaultAppsShortcuts = enabled;
        # fonts = enabled;
      };
      scripts = {
        nx = {
          enable = true;

          # Auto-update wallpaper repo
          rebuild.preRebuildActions = ''
            echo "Updating wallpaper flake"
            nix flake update wallpapers --allow-dirty
            git add flake.lock
          '';
        };

        # terminalUtils = enabled;

        # snip = enabled;
        # clipboard = enabled;
      };
    };
  };
}
