{
  lib,
  options,
  config,
  inputs,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;

  userCfg = config.my.user;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options.my.hm = mkOption {
    description = "Options to pass directly to home-manager.";
    type = types.attrs;
    default = { };
  };

  config = mkIf (userCfg.enable) {
    # Home-Manager config
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # On activation move existing files by appending the given file extension rather than exiting with an error.
      # Applies to home.file and also xdg.*File
      backupFileExtension = "bak";

      users.${userCfg.name} = lib.mkAliasDefinitions options.my.hm;
    };

    my.hm = {
      # Do not change
      home.stateVersion = "24.05";

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = userCfg.name;
      home.homeDirectory = userCfg.home;

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # Customize default directories
      xdg.userDirs = {
        enable = true;
        createDirectories = true;

        download = "${userCfg.home}/downloads";

        music = "${userCfg.home}/media";
        pictures = "${userCfg.home}/media";
        videos = "${userCfg.home}/media";

        desktop = "${userCfg.home}/misc";
        documents = "${userCfg.home}/misc";
        publicShare = "${userCfg.home}/misc";
      };
    };
  };
}
