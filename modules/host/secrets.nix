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

    # Add automatically extracted secrets to agenix config
    secrets = traceValSeq (
      extractedSecrets
      // {
        "wifi/eduroam-ca.pem" = extractedSecrets."wifi/eduroam-ca.pem" // {
          owner = "root";
          group = "root";
        };
      }

    );

  };
}
