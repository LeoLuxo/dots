{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.desktop.autologin;
in
{
  options.ext.desktop.autologin = {
    enable = lib.mkEnableOption "desktop manager autologin";
  };

  config = lib.mkIf cfg.enable {
    # Enable automatic login for the user.
    services.displayManager.autoLogin = {
      enable = true;
      user = config.ext.system.user.name;
    };
  };
}
