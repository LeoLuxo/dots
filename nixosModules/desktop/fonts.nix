{
  lib,
  config,
  pkgs-unstable,
  ...
}:

let
  cfg = config.my.desktop.fonts;
in
{
  options.my.desktop.fonts = {
    enable = lib.mkEnableOption "enable default fonts";
  };

  config = lib.mkIf cfg.enable {
    my.packages = with pkgs-unstable; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.mononoki
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };
}
