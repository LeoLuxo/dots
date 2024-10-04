{ lib, ... }:
with builtins;
with lib;
let
  # Extract all secrets from secrets.nix (used by agenix) and automatically add them to the agenix module config
  secretsPath = builtins.fetchGit {
    url = "ssh://git@github.com/LeoLuxo/nix-secrets";
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
    # And edit some fields where needed by recursive-merging the sets
    secrets = attrsets.recursiveUpdate extractedSecrets {
      "wifi/eduroam-ca.pem" = {
        owner = "root";
        group = "root";
        mode = "600";
      };
    };
  };
}
