{
  lib,
  config,
  pkgs,
  lib2,
  user,
  ...
}:

let
  inherit (lib) types;
  inherit (lib2) enabled;
  inherit (lib.options) mkOption;

  cfg = config.my.system.wifi;
in
{
  options.my.system.wifi = {
    enable = lib.mkEnableOption "wifi networks";

    enabledNetworks = mkOption {
      description = "enabled networks";
      type = types.listOf types.string;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Fix eduroam certificate
    age.secrets."wifi/eduroam-ca.pem" = {
      # Required by NetworkManager otherwise it won't work
      owner = "root";
      group = "root";
      mode = "755";
    };

    networking.networkmanager = {
      # Enable networking with NetworkManager
      enable = true;

      ensureProfiles = {
        environmentFiles = [
          config.age.secrets."wifi/networkmanager-env".path
        ];

        profiles = lib.getAttrs cfg.enabledNetworks (import ./networks.nix config);
      };
    };
  };
}
