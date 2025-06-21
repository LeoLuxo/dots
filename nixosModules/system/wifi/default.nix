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

  cfg = config.my.system.wifi;
in
{
  options.my.system.wifi = with lib2.options; {
    enable = lib.mkEnableOption "wifi networks";
    enabledNetworks = mkOpt "enabled networks" (types.listOf types.string) [ ];
  };

  config = lib.mkIf cfg.enable {
    my.nix.secrets = enabled;

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
