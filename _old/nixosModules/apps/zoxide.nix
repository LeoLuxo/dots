{
  lib,
  config,
  ...
}:

let
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.zoxide;
in

# zoxide, the smarter `cd` command
{
  options.zoxide = {
    enableAlias = mkEnableOption "the cd='z' alias" // {
      default = true;
    };
  };

  config = {
    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    home-manager.users.${config.my.user.name}.programs.fish.functions = mkIf cfg.enableAlias {
      cd = ''
        # If the 'z' command exists, use it, otherwise fall back to builtin cd
        # (For reason my vscode builtin terminal doesn't have accesss to 'z')
        if type -q z
            z $argv
        else
            builtin cd $argv
        end
      '';
    };
  };
}
