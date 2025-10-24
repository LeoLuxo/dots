{
  lib,
  config,
  pkgs,
  lib2,
  user,
  ...
}:

let

  inherit (lib2) enabled;
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

    # home-manager.users.${user}.home.shellAliases = mkIf cfg.enableAlias {
    #   cd = "z";
    # };

    home-manager.users.${user}.programs.fish.functions = mkIf cfg.enableAlias {
      cd = ''
        if type -q z
            z $argv
        else
            builtin cd $argv
        end
      '';
    };
  };
}
