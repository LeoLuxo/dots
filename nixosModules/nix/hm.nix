{
  lib,
  options,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  userCfg = config.ext.system.user;
in
{
  options.ext.hm =
    with lib2.options;
    mkOpt "Options to pass directly to home-manager." types.attrs { };

  config = lib.mkIf (userCfg != null) {
    # Home-Manager config
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # On activation move existing files by appending the given file extension rather than exiting with an error.
      # Applies to home.file and also xdg.*File
      backupFileExtension = "bak";

      users.${userCfg.name} = lib.mkAliasDefinitions options.ext.hm;
    };

    ext.hm = {
      # Do not change
      home.stateVersion = "24.05";

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = userCfg.user;
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
