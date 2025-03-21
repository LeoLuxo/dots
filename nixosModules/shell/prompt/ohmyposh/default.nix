{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.shell.prompt.ohmyposh;
in
{
  options.ext.shell.prompt.ohmyposh = {
    enable = lib.mkEnableOption "ohmyposh shell prompt";
  };

  config = lib.mkIf cfg.enable {
    ext.hm = {
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
