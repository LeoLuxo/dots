{
  lib,
  config,
  pkgs-unstable,
  ...
}:

let
  cfg = config.ext.desktop.fonts;
in
{
  options.ext.desktop.fonts = {
    enable = lib.mkEnableOption "enable default fonts";
  };

  config = lib.mkIf cfg.enable {
    ext.packages = with pkgs-unstable; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.mononoki
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };
}
