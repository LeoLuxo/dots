{ lib, ... }:
with builtins;
with lib;
let
  # Extract all secrets from secrets.nix (used by agenix) and automatically add them to the agenix module config
  secretsPath = builtins.fetchGit {
    url = "ssh://git@github.com/LeoLuxo/nix-secrets.git";
    ref = "main";
  };
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
    identityPaths = [ "/root/.ssh/id_ed25519" ];

    # Add automatically extracted secrets to agenix config
    secrets = traceValSeq (
      extractedSecrets
      // {
        "wifi/eduroam-ca.pem" = extractedSecrets."wifi/eduroam-ca.pem" // {
          owner = "root";
          group = "root";
          mode = "600";
        };
      }

    );

  };
}
