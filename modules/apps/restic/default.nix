{
  config,
  pkgs,
  constants,
  lib,
  extraLib,
  ...
}:

let
  inherit (extraLib) mkBoolDefaultFalse;
  inherit (constants) user;
  inherit (lib) options types modules;
in

{
  imports = [ ./cold.nix ];

  options.restic = {
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
      cfg = config.restic;

      commands = {
        restic = "RESTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) restic --repo ${cfg.repo}";
        rustic = "RUSTIC_PASSWORD=$(sudo cat ${cfg.passwordFile}) rustic --repo ${cfg.repo}";
      };
    in
    modules.mkIf cfg.enable {
      home-manager.users.${user} = {
        home.packages = with pkgs; [
          sshpass
          restic
          rustic
        ];

        home.shellAliases = {
          # Add aliases for the main repo
          restic2 = commands.restic;
          rustic2 = commands.rustic;
        };
      };

      environment.variables = {
        # RESTIC_STORAGE_BOX_ADDR_FILE = config.age.secrets."restic/storage-box-addr".path;
        # RESTIC_STORAGE_BOX_PWD_FILE = config.age.secrets."restic/storage-box-pwd".path;

        # RESTIC_REPO_HOT = constants.resticRepoHot;
        # RESTIC_REPO_COLD = constants.resticRepoCold or "";
      };
    };
}
