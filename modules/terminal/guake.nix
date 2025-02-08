{
  config,
  lib,

  constants,
  pkgs,
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
    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        guake
      ];
    };

    # Needs to start on boot
  };
}
