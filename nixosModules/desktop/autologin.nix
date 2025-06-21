{
  lib,
  config,
  ...
}:

let
  cfg = config.my.desktop.autologin;
in
{
  options.my.desktop.autologin = {
    enable = lib.mkEnableOption "desktop manager autologin";
  };

  config = lib.mkIf cfg.enable {
    # Enable automatic login for the user.
    services.displayManager.autoLogin = {
      enable = true;
      user = config.my.system.user.name;
    };
  };
}
