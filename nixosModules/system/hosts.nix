{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib2) enabled;
  inherit (lib) types;

  cfg = config.ext.hosts;
in
{
  options.ext.hosts = with lib2.options; {
    enable = lib.mkEnableOption "local hosts";
  };

  config = lib.mkIf cfg.enable {
    networking.hosts = {
      "192.168.0.37" = [ "strobery" ];
      # "192.168.0.37" = [ "coffee" ];
      # "192.168.0.37" = [ "pancake" ];
    };
  };
}
