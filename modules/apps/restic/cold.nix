{
  config,
  lib,

  ...
}:

let
  inherit (extraLib) mkEnable;
  inherit (lib) options types modules;
in

{
  options.coldBackup = {
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
      localCfg = cfg.coldBackup;
    in
    modules.mkIf localCfg.enable {
      shell.aliases = {
        # Add aliases for the cold repo
        restic-cold = "RESTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) restic --repo ${cfg.repo}";
        rustic-cold = "RUSTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) rustic --repo ${cfg.repo}";
      };
    };
}
