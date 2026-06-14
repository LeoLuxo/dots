{ config, ... }:

{
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

      profiles = {
        "Home" = {
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

        "Parents" = {
          connection = {
            id = "Domaine des fleurs de jardin";
            interface-name = "wlp0s20f3";
            type = "wifi";
            uuid = "15f9f454-b8c8-4441-8ab8-a42acbfd6c6c";
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
            ssid = "Domaine des fleurs de jardin";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$DOMAINE_DES_FLEURS_DE_JARDIN_PSK";
          };
        };

        "AU Eduroam" = {
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

        "MichiZuzu" = {
          connection = {
            id = "Wifi26E0";
            interface-name = "wlp0s20f3";
            type = "wifi";
            uuid = "9c19ca26-30af-4d64-9889-459b4f1e8646";
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
            ssid = "Wifi26E0";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
            psk = "$MICHI_PSK";
          };
        };
      };
    };
  };
}
