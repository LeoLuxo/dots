{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.desktop.terminal.guake;
in
{
  options.my.desktop.terminal.guake = {
    enable = lib.mkEnableOption "the Guake terminal";
  };

  config = lib.mkIf cfg.enable {
    my.packages = with pkgs; [
      guake
    ];
  };
}
