{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.desktop.fonts;
in
{
  imports = [

  ];

  options.ext.desktop.fonts = {
    enable = lib.mkEnableOption "enable default fonts";
  };

  config = lib.mkIf cfg.enable {
    ext.packages = with pkgs; [
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.mononoki
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
    ];
  };
}
