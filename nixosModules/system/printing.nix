{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.system.printing;
in
{
  options.ext.system.printing = {
    enable = lib.mkEnableOption "printing";
  };

  config = lib.mkIf cfg.enable {
    # Enable CUPS to print documents.
    services.printing.enable = true;
  };
}
