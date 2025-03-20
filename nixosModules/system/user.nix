{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.ext.system.user;
  lib2 = inputs.self.lib;

  inherit (lib) types;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.ext.system.user =
    with lib2.options;
    mkSubmoduleNull "the options when setting up a single-user machine" (rec {
      name = mkOpt' "the name of the default user" types.str;

      home = mkOpt "the home folder" types.path "/home/${cfg.name}";

      passwordFile = mkOpt "the hashed password file" (types.nullOr types.path) (
        if config.secrets.enable then config.age.secrets."userpwds/${home}".path else null
      );
    });

  config = lib.mkIf (cfg != null) {
    # Define default user account.
    users = {
      mutableUsers = false;

      users.${cfg.name} = {
        home = cfg.home;
        description = cfg.name;
        isNormalUser = true;

        hashedPasswordFile = lib.mkIf (cfg.passwordFile != null) cfg.passwordFile;

        extraGroups = [
          "networkmanager"
          "wheel"
        ];
      };
    };
  };
}
