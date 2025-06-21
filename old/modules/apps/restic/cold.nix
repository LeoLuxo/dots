{
  config,
  constants,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkBoolDefaultFalse;

  inherit (lib) options types modules;
in

{
  options.restic.coldBackup = {
    enable = mkBoolDefaultFalse;

    repo = options.mkOption {
      type = types.path;
    };

    passwordFile = options.mkOption {
      type = types.path;
    };
  };

  config =
    let
      cfg = config.restic.coldBackup;
    in
    modules.mkIf cfg.enable {
      home-manager.users.${config.ext.system.user.name} = {
        home.shellAliases = {
          # Add aliases for the cold repo
          restic3 = "RESTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) restic --repo ${cfg.repo}";
          rustic3 = "RUSTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) rustic --repo ${cfg.repo}";
        };
      };
    };
}
