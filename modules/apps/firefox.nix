{
  config,
  lib,

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
    desktop.defaultsApps.browser = lib.mkDefault "firefox";

    programs = {
      # Setup firefox.
      firefox = {
        enable = true;
        policies =
          let
            lock-false = {
              Value = false;
              Status = "locked";
            };
          in
          # lock-true = {
          #   Value = true;
          #   Status = "locked";
          # };
          {
            Preferences = {
              "middlemouse.paste" = lock-false;
            };
          };
      };
    };
  };
}
