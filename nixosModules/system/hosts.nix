{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.system.hosts;
in
{
  options.ext.system.hosts = {
    enable = lib.mkEnableOption "local hosts";
  };

  config = lib.mkIf cfg.enable {
    networking.hosts = {
      "192.168.0.37" = [ "strobery" ];
      "192.168.0.88" = [ "coffee" ];
      "192.168.0.173" = [ "pancake" ];
    };
  };
}
