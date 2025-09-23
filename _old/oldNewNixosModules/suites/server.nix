{
  lib,
  config,
  ...
}:

let

  cfg = config.my.suites.server;
in
{
  options.my.suites.server = {
    enable = lib.mkEnableOption "the server suite";
  };

  config = lib.mkIf cfg.enable {
  };
}
