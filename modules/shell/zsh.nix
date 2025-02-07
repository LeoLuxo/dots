{
  cfg,
  lib,
  extraLib,
  pkgs,
  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    shell.defaultShell = lib.mkDefault "zsh";

    programs.zsh.enable = true;
    environment.shells = [ pkgs.zsh ];

    home-manager.users.${constants.user} = {
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
