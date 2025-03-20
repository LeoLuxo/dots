{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
  inherit (lib) types;

  cfg = config.ext.system.wifi;
in
{
  options.ext.system.wifi = with lib2.options; {
    enable = lib.mkEnableOption "wifi networks";
    enabledNetworks = mkOpt "enabled networks" (types.listOf types.string) [ ];
  };

  config = lib.mkIf cfg.enable {
    ext.secrets = enabled;

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
