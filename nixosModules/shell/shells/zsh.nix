{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.shell.zsh;
in
{
  options.ext.shell.zsh = {
    enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf cfg.enable {
    ext.shell.defaultShell = lib.mkDefault "zsh";

    programs.zsh.enable = true;
    environment.shells = [ pkgs.zsh ];

    ext.hm = {
      programs.zsh = {
        enable = true;

        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        history = {
          size = 10000;
          ignoreAllDups = true;
        };
      };
    };
  };
}
