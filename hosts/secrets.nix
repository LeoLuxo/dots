{
  userHome,
  lib,
  agenix,
  system,
  secretsRepoPath,
  ...
}:
with builtins;
with lib;
let
  # Extract all secrets from secrets.nix (used by agenix) and automatically add them to the agenix module config
  secretsPath = builtins.fetchGit {
    # url = "ssh://git@github.com/LeoLuxo/nix-secrets";
    url = secretsRepoPath;
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

  imports = [
    # Include agenix module
    agenix.nixosModules.default
  ];

  environment.systemPackages = [
    # Install agenix CLI
    agenix.packages.${system}.default
  ];

  age = {
    # Use the host key OR user key
    identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "${userHome}/.ssh/id_ed25519"
    ];

    # Add automatically extracted secrets to agenix config
    # And edit some fields where needed by recursive-updating the sets
    secrets = attrsets.recursiveUpdate extractedSecrets {
      "wifi/eduroam-ca.pem" = {
        # Required by NetworkManager
        owner = "root";
        group = "root";
        mode = "755";
      };
    };
  };

}
