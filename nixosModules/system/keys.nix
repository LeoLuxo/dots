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
      mkAttrsSubDefault "keys accessible to the config"
        {
          public = mkOpt "the public key path" types.path;
          private = mkOpt "the private key path" types.path;
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
