{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.ext.system.keys;
in
{
  options.ext.system.keys = with lib2.options; {
    enable = lib.mkEnableOption "key management";

    keys =
      mkAttrsSub "keys accessible to the config"
        {
          public = mkOpt' "the public key path" types.path;
          private = mkOpt' "the private key path" types.path;
        }
        {
          user = lib.mkIf (config.ext.system.user != null) {
            private = "${config.ext.system.user.home}/.ssh/id_ed25519";
            public = "${config.ext.system.user.home}/.ssh/id_ed25519.pub";
          };

          host = {
            private = "/etc/ssh/ssh_host_ed25519_key";
            public = "/etc/ssh/ssh_host_ed25519_key.pub";
          };
        };
  };

  config =
    lib.mkIf cfg.enable
      {
      };
}
