{
  lib,
  config,
  ...
}:

let

  cfg = config.ext.suites.pc;
in
{
  options.ext.suites.pc = {
    enable = lib.mkEnableOption "the server suite";
  };

  config = lib.mkIf cfg.enable {
  };
}
