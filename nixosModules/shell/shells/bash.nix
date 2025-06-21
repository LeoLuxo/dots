{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.shell.bash;
in
{
  options.my.shell.bash = {
    enable = lib.mkEnableOption "bash";
  };

  config = lib.mkIf cfg.enable {
    my = {
      shell.defaultShell = lib.mkDefault "bash";

      # Let home manager manage bash; needed to set sessionVariables
      hm.programs.bash = {
        enable = true;
      };
    };

    environment.shells = [ pkgs.bash ];
  };
}
