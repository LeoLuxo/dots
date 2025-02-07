{
  cfg,
  lib,
  extraLib,
  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    users.users.${constants.user}.extraGroups = [
      "docker"
    ];
  };
}
