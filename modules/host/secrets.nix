{ lib, ... }:
with builtins;
with lib;
let
  # Extract all secrets from secrets.nix (used by agenix) and automatically add them to the agenix module config
  secretsPath = "/etc/nixos/secrets";
  secretsFile = "${secretsPath}/secrets.nix";
  extractedSecrets =
    if pathExists secretsFile then
      mapAttrs' (
        n: _:
        nameValuePair (removeSuffix ".age" n) {
          file = "${secretsPath}/${n}";
        }
      ) (import secretsFile)
    else
      { };
in
{
  age = {
    # For some reason I need to explicitly override it
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # Override certain properties of certain secrets
    secrets = traceValSeq extractedSecrets
    # // (
    #   extractedSecrets."wifi/celeste-mountain.nmconnection"
    #   // {
    #     path = "/etc/NetworkManager/system-connections/celeste-mountain.nmconnection";
    #     mode = "600";
    #     owner = "root";
    #     group = "root";
    #   }
    # )
    # // (
    #   extractedSecrets."wifi/eduroam.nmconnection"
    #   // {
    #     path = "/etc/NetworkManager/system-connections/eduroam.nmconnection";
    #     mode = "600";
    #     owner = "root";
    #     group = "root";
    #   }
    # )
    # // (
    #   extractedSecrets."wifi/eduroam-ca.pem"
    #   // {
    #     path = "/etc/NetworkManager/system-connections/eduroam-ca.pem";
    #     mode = "600";
    #     owner = "root";
    #     group = "root";
    #   }
    # )
    ;

  };
}
