{ config, ... }:

{
  networking.networkmanager = {
    # Enable networking with NetworkManager
    enable = true;

    ensureProfiles = {
      environmentFiles = [
        config.age.secrets."wifi/networkmanager-env".path
      ];

      profiles = {
        "Celeste Mountain" = {
          connection = {
            id = "Celeste Mountain";
            interface-name = "wlp0s20f3";
            type = "wifi";
            uuid = "4b899b53-7cd4-48c5-a7d5-56b598c6b9aa";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "default";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "Celeste Mountain";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$CELESTE_MOUNTAIN_PSK";
          };
        };

        eduroam = {
          "802-1x" = {
            ca-cert = config.age.secrets."wifi/eduroam-ca.pem".path;
            eap = "peap;";
            identity = "$EDUROAM_IDENTITY";
            password = "$EDUROAM_PASSWORD";
            phase1-peapver = "1";
            phase2-auth = "mschapv2";
          };
          connection = {
            id = "eduroam";
            type = "wifi";
            uuid = "2203ce9e-afc1-4e35-9a0c-92fa749bb33a";
          };
          ipv4 = {
            method = "auto";
          };
          ipv6 = {
            addr-gen-mode = "stable-privacy";
            method = "auto";
          };
          proxy = { };
          wifi = {
            mode = "infrastructure";
            ssid = "eduroam";
          };
          wifi-security = {
            key-mgmt = "wpa-eap";
          };
        };
      };
    };
  };
}
