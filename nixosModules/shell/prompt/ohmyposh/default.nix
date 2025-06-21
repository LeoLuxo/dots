{
  lib,
  config,
  ...
}:

let
  cfg = config.my.shell.prompt.ohmyposh;
in
{
  options.my.shell.prompt.ohmyposh = {
    enable = lib.mkEnableOption "ohmyposh shell prompt";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
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
