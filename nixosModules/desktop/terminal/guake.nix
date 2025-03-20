{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.desktop.terminal.guake;
in
{
  options.ext.desktop.terminal.guake = {
    enable = lib.mkEnableOption "the Guake terminal";
  };

  config = lib.mkIf cfg.enable {
    ext.packages = with pkgs; [
      guake
    ];
  };
}
