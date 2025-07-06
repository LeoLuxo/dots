{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

in
{
  options.my.keys =
    with lib2.options;
    mkAttrsSubDefault "key pairs available on the machine and accessible to the other nixos modules"
      {
        public = mkOpt "the path of this pair's public key" types.path;
        private = mkOpt "the path of this pair's private key" types.path;
      }
      {
        user = lib.mkIf (config.my.user != null) {
          private = "${config.my.user.home}/.ssh/id_ed25519";
          public = "${config.my.user.home}/.ssh/id_ed25519.pub";
        };

        host = {
          private = "/etc/ssh/ssh_host_ed25519_key";
          public = "/etc/ssh/ssh_host_ed25519_key.pub";
        };
      };
}
