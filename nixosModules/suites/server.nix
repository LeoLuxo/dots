{
  lib,
  config,
  ...
}:

let

  cfg = config.my.suites.pc;
in
{
  options.my.suites.pc = {
    enable = lib.mkEnableOption "the server suite";
  };

  config = lib.mkIf cfg.enable {
  };
}
