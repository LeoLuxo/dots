{
  lib,
  agenix,
  constants,
  ...
}:

let
  inherit (constants)
    system
    secretsRepoPath
    userKeyPrivate
    hostKeyPrivate
    ;
  inherit (lib) attrsets strings;
in

let
  # Fetch secrets from private repo
  # Secrets are SUPPOSED to be fully indepent from the dots in my opinion, thus this (intentionally) makes my dots impure
  secretsPath = builtins.fetchGit {
    # url = "ssh://git@github.com/LeoLuxo/nix-secrets";
    url = secretsRepoPath;
  };

  # Extract all secrets from secrets.nix (used by agenix) and automatically add them to the agenix module config
  secretsFile = "${secretsPath}/secrets.nix";

  extractedSecrets =
    if builtins.pathExists secretsFile then
      attrsets.mapAttrs' (
        n: _:
        attrsets.nameValuePair (strings.removeSuffix ".age" n) {
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
      hostKeyPrivate
      userKeyPrivate
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
