{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) mkAttrs;
  inherit (lib) types;
  inherit (lib.options) mkOption;

in
{
  options.my.keys = mkAttrs {
    description = "key pairs available on the machine and accessible to the other nixos modules";

    options = {
      public = mkOption {
        description = "the path of this pair's public key";
        type = types.path;
      };
      private = mkOption {
        description = "the path of this pair's private key";
        type = types.path;
      };
    };

    default = {
      user = lib.mkIf (config.my.user != null) {
        private = "${config.my.user.home}/.ssh/id_ed25519";
        public = "${config.my.user.home}/.ssh/id_ed25519.pub";
      };

      host = {
        private = "/etc/ssh/ssh_host_ed25519_key";
        public = "/etc/ssh/ssh_host_ed25519_key.pub";
      };
    };
  };
}
