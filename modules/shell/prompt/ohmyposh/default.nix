{
  cfg,
  lib,
  extraLib,
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
      programs.oh-my-posh = {
        enable = true;
        settings = import ./theme.nix;

        enableBashIntegration = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        enableFishIntegration = true;
      };
    };
  };
}
