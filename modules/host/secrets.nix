{ lib, ... }:
with builtins;
with lib;
let
  secretsPath = /etc/nixos/secrets;
  secretsFile = "${secretsPath}/secrets.nix";
in
{
  age = {
    # For some reason I need to explicitly override it
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets =
      if pathExists secretsFile then
        mapAttrs' (
          n: _:
          nameValuePair (removeSuffix ".age" n) {
            file = "${secretsPath}/${n}";
          }
        ) (import secretsFile)
      else
        { };
  };
}
