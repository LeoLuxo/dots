{
  lib,
  config,
  hostname,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.system.user;
in
{
  # Alias for convenience
  imports = [
    (lib.mkAliasOptionModule [ "my" "user" ] [ "my" "system" "user" ])
  ];

  options.my.system.user = {
    enable = mkOption {
      description = "whether to consider this nixos config to be single-user";
      type = types.bool;
      default = cfg.name != null;
    };

    name = mkOption {
      description = "the name of the default user";
      type = types.str;
    };

    home = mkOption {
      description = "the home folder";
      type = types.path;
      default = "/home/${cfg.name}";
    };

    uid = mkOption {
      description = "the user id";
      type = types.int;
      default = 1000;
    };

    passwordFile = mkOption {
      description = "the hashed password file";
      type = types.nullOr types.path;
      default = config.age.secrets."userpwds/${hostname}/${cfg.name}".path;
    };

    extraGroups = mkOption {
      description = "the user's auxiliary groups";
      type = types.listOf types.str;
      default = [
        "networkmanager"
      ];
    };
  };

  config = mkIf cfg.enable {
    # Define default user account.
    users = {
      mutableUsers = false;

      users.${cfg.name} = {
        home = cfg.home;
        description = cfg.name;
        isNormalUser = true;
        hashedPasswordFile = mkIf (cfg.passwordFile != null) cfg.passwordFile;
        extraGroups = [ "wheel" ] ++ cfg.extraGroups;
        uid = cfg.uid;
      };
    };
  };
}
