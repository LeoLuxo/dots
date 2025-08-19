{
  lib,
  config,
  ...
}:

let
  cfg = config.my.system.printing;
in
{
  options.my.system.printing = {
    enable = lib.mkEnableOption "printing";
  };

  config = lib.mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
