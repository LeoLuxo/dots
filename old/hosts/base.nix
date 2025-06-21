{
  config,
  inputs,
  nixosModulesOld,
  ...
}:

{
  imports = [
    # Include home manager module
    inputs.home-manager.nixosModules.home-manager

    nixosModulesOld.defaults
  ];

  # Home-Manager config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    # On activation move existing files by appending the given file extension rather than exiting with an error.
    # Applies to home.file and also xdg.*File
    backupFileExtension = "bak";

    users.${config.ext.system.user.name} = {
      # Do not change
      home.stateVersion = "24.05";

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = config.ext.system.user.name;
      home.homeDirectory = config.ext.system.user.home;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };

  # # Define default user account.
  # users = {
  #   mutableUsers = false;

  #   users.${user} = {
  #     home = userHome;
  #     description = user;
  #     isNormalUser = true;
  #     hashedPasswordFile = config.age.secrets."userpwds/${hostname}".path;
  #     extraGroups = [
  #       "networkmanager"
  #       "wheel"
  #     ];
  #   };
  # };
}
