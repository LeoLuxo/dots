{
  config,
  pkgs,
  constants,
  lib,
  ...
}:

let
  inherit (constants) user hostName;
  inherit (lib) modules;
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      sshpass
      restic
      rustic
    ];

    home.shellAliases =
      {
        # Add aliases for the hot repo
        restic-hot = "RESTIC_PASSWORD=$(sudo cat $RESTIC_PWD_FILE) restic --repo ${constants.resticRepoHot}";
        rustic-hot = "RUSTIC_PASSWORD=$(sudo cat $RESTIC_PWD_FILE) rustic --repo ${constants.resticRepoHot}";
      }
      // (modules.mkIf (constants ? resticRepoCold) {
        # Add aliases for the cold repo (optionally)
        restic-cold = "RESTIC_PASSWORD=$(sudo cat $RESTIC_PWD_FILE) restic --repo ${constants.resticRepoCold}";
        rustic-cold = "RUSTIC_PASSWORD=$(sudo cat $RESTIC_PWD_FILE) rustic --repo ${constants.resticRepoCold}";
      });
  };

  environment.variables = {
    RESTIC_PWD_FILE = config.age.secrets."restic/${hostName}-pwd".path;
    RESTIC_STORAGE_BOX_ADDR_FILE = config.age.secrets."restic/storage-box-addr".path;
    RESTIC_STORAGE_BOX_PWD_FILE = config.age.secrets."restic/storage-box-pwd".path;

    RESTIC_REPO_HOT = constants.resticRepoHot;
    RESTIC_REPO_COLD = constants.resticRepoCold or "";
  };
}
