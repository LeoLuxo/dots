{
  config,
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      ssh
      sshpass
      restic
    ];
  };

  environment.variables = {
    STORAGE_BOX_ADDR_FILE = config.age.secrets."storage-box-address".path;
    STORAGE_BOX_PWD_FILE = config.age.secrets."storage-box-pwd".path;
  };
}
