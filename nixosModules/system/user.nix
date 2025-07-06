{
  lib,
  config,
  inputs,
  hostname,
  ...
}:

let
  cfg = config.my.user;
  lib2 = inputs.self.lib;

  inherit (lib) types;
in
{

  options.my.user = with lib2.options; {
    enable = mkOptDefault "whether to consider this config to be single-user" types.bool (
      cfg.name != null
    );

    name = mkOpt "the name of the default user" types.str;

    home = mkOptDefault "the home folder" types.path "/home/${cfg.name}";

    uid = mkOptDefault "the user id" types.int 1000;

    passwordFile = mkOptDefault "the hashed password file" (types.nullOr types.path) (
      if config.my.secretManagement.enable then config.my.secrets."userpwds/${hostname}" else null
    );

    extraGroups = mkOptDefault "the user's auxiliary groups" (types.listOf types.str) [
      "networkmanager"
    ];
  };

  config = lib.mkIf cfg.enable {
    # Define default user account.
    users = {
      mutableUsers = false;

      users.${cfg.name} = {
        home = cfg.home;
        description = cfg.name;
        isNormalUser = true;
        hashedPasswordFile = lib.mkIf (cfg.passwordFile != null) cfg.passwordFile;
        extraGroups = [ "wheel" ] ++ cfg.extraGroups;
        uid = cfg.uid;
      };
    };

    nix.settings = {
      trusted-users = [
        cfg.name
      ];
    };
  };
}
