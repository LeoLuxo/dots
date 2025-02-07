{
  config,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkEnable;
  inherit (lib) options types modules;
in

{
  options.restic.coldBackup = {
    enable = mkEnable;

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
      shell.aliases = {
        # Add aliases for the cold repo
        restic-cold = "RESTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) restic --repo ${cfg.repo}";
        rustic-cold = "RUSTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) rustic --repo ${cfg.repo}";
      };
    };
}
