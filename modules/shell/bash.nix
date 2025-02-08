{
  config,
  lib,

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
    shell.defaultShell = lib.mkDefault "bash";

    environment.shells = [ pkgs.bash ];

    home-manager.users.${constants.user} = {
      # Let home manager manage bash; needed to set sessionVariables
      programs.bash = {
        enable = true;
      };
    };
  };
}
