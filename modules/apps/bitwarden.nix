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
    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [ bitwarden-desktop ];
    };
  };
}
