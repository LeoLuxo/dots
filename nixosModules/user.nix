{
  lib,
  config,
  inputs,
  ...
}:

let
  cfg = config.ext.user;
  lib2 = inputs.lib;

  inherit (lib) types;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.ext.user =
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

    # Home-Manager config
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # On activation move existing files by appending the given file extension rather than exiting with an error.
      # Applies to home.file and also xdg.*File
      backupFileExtension = "bak";

      users.${cfg.user} = {
        # Do not change
        home.stateVersion = "24.05";

        # Home Manager needs a bit of information about you and the paths it should manage.
        home.username = cfg.user;
        home.homeDirectory = cfg.home;

        # Let Home Manager install and manage itself.
        programs.home-manager.enable = true;
      };
    };
  };
}
