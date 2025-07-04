{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.my.system.keys;
in
{
  options.my.system.keys = with lib2.options; {
    enable = lib.mkEnableOption "key management";

    keys =
      mkAttrsSubDefault "key pairs accessible to the other nixos modules"
        {
          public = mkOpt "the path of this pair's public key" types.path;
          private = mkOpt "the path of this pair's private key" types.path;
        }
        {
          user = lib.mkIf (config.my.system.user != null) {
            private = "${config.my.system.user.home}/.ssh/id_ed25519";
            public = "${config.my.system.user.home}/.ssh/id_ed25519.pub";
          };

          host = {
            private = "/etc/ssh/ssh_host_ed25519_key";
            public = "/etc/ssh/ssh_host_ed25519_key.pub";
          };
        };
  };

  config = lib.mkIf cfg.enable {
  };
}
