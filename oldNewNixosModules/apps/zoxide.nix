{
  lib,
  config,
  pkgs,
  lib2,
  ...
}:

let

  inherit (lib2) enabled;
  inherit (lib.options) mkEnableOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.apps.zoxide;
in
{
  options.my.apps.zoxide = {
    enable = mkEnableOption "zoxide, the smarter cd command";

    enableAlias = mkEnableOption "the cd='z' alias" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.zoxide = enabled;

    home-manager.users.${config.my.user.name}.home.shellAliases = mkIf cfg.enableAlias {
      cd = "z";
    };
  };
}
