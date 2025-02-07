{
  cfg,
  lib,
  constants,
  extraLib,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options.autoLogin = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.autoLogin.enable {
    customs = {

    };

    # Enable automatic login for the user.
    services.displayManager.autoLogin = {
      enable = true;
      user = constants.user;
    };
  };
}
