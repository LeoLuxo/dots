{
  config,
  lib,
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
    # Enable automatic login for the user.
    services.displayManager.autoLogin = {
      enable = true;
      user = constants.user;
    };
  };
}
