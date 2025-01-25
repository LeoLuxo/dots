{
  config,
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user hostName;
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      sshpass
      restic
      rustic
    ];
  };

  environment.variables = {
    RESTIC_PWD_FILE = config.age.secrets."restic/${hostName}-pwd".path;
    RESTIC_STORAGE_BOX_ADDR_FILE = config.age.secrets."restic/storage-box-addr".path;
    RESTIC_STORAGE_BOX_PWD_FILE = config.age.secrets."restic/storage-box-pwd".path;
  };
}
