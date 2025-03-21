{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.shell.bash;
in
{
  options.ext.shell.bash = {
    enable = lib.mkEnableOption "bash";
  };

  config = lib.mkIf cfg.enable {
    ext = {
      shell.defaultShell = lib.mkDefault "bash";

      # Let home manager manage bash; needed to set sessionVariables
      hm.programs.bash = {
        enable = true;
      };
    };

    environment.shells = [ pkgs.bash ];
  };
}
