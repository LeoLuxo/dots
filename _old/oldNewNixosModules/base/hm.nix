{
  lib,
  options,
  config,
  inputs,
  user,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;
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

  config = {
    # Home-Manager config
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      # On activation move existing files by appending the given file extension rather than exiting with an error.
      # Applies to home.file and also xdg.*File
      backupFileExtension = "bak";

      users.${user} = lib.mkAliasDefinitions options.my.hm;
    };

    my.hm = {
      # Do not change
      home.stateVersion = "24.05";

      # Home Manager needs a bit of information about you and the paths it should manage.
      home.username = user;
      home.homeDirectory = "/home/${user}";

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;

      # Customize default directories
      xdg.userDirs = {
        enable = true;
        createDirectories = true;

        download = "/home/${user}/downloads";

        music = "/home/${user}/media";
        pictures = "/home/${user}/media";
        videos = "/home/${user}/media";

        desktop = "/home/${user}/misc";
        documents = "/home/${user}/misc";

        templates = null;
        publicShare = null;
      };
    };
  };
}
