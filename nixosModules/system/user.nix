{
  lib,
  options,
  config,
  inputs,
  hostname,
  ...
}:

let
  cfg = config.ext.system.user;
  lib2 = inputs.self.lib;

  inherit (lib) types;
in
{

  options.ext.system.user = with lib2.options; {
    enable = mkOpt "whether to consider this config to be single-user" types.bool (cfg.name != null);

    name = mkOpt' "the name of the default user" types.str;

    home = mkOpt "the home folder" types.path "/home/${cfg.name}";

    passwordFile = mkOpt "the hashed password file" (types.nullOr types.path) (
      # if config.secrets.enable then config.age.secrets."userpwds/${hostname}".path else null
      config.age.secrets."userpwds/${hostname}".path
    );

    extraGroups = mkOpt "the user's auxiliary groups" (types.listOf types.str) [ "networkmanager" ];
  };

  config = lib.mkIf (lib.traceVal cfg.enable) {
    # Define default user account.
    users = {
      mutableUsers = false;

      users.${cfg.name} = {
        home = cfg.home;
        description = cfg.name;
        isNormalUser = true;
        hashedPasswordFile = lib.mkIf (cfg.passwordFile != null) cfg.passwordFile;
        extraGroups = [ "wheel" ] ++ cfg.extraGroups;
      };
    };

    nix.settings = {
      trusted-users = [
        cfg.name
      ];
    };
  };
}
