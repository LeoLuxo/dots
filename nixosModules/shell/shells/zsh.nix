{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.shell.zsh;
in
{
  options.my.shell.zsh = {
    enable = lib.mkEnableOption "zsh";
  };

  config = lib.mkIf cfg.enable {
    my = {
      shell.defaultShell = lib.mkDefault "zsh";

      hm = {
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

    programs.zsh.enable = true;
    environment.shells = [ pkgs.zsh ];
  };
}
