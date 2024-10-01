{ ... }:
let
  secretsPath = /etc/nixos/secrets;
in
{
  age = {
    # For some reason I need to explicitly override it
    identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      pancake-user-password.file = secretsPath + "/userpwds/pancake.age";

      syncthing-pancake-id.file = secretsPath + "/syncthing/pancake/id.age";
      syncthing-pancake-cert.file = secretsPath + "/syncthing/pancake/cert.pem.age";
      syncthing-pancake-key.file = secretsPath + "/syncthing/pancake/key.pem.age";

      syncthing-neon-id.file = secretsPath + "/syncthing/neon/id.age";
      syncthing-neon-cert.file = secretsPath + "/syncthing/neon/cert.pem.age";
      syncthing-neon-key.file = secretsPath + "/syncthing/neon/key.pem.age";
    };
  };

}
