{
  lib,
  config,
  ...
}:

let
  cfg = config.ext.shell.prompt.starship;
in
{
  options.ext.shell.prompt.starship = {
    enable = lib.mkEnableOption "starship shell prompt";
  };

  config = lib.mkIf cfg.enable {
    ext.hm = {
      programs.starship = {
        enable = true;

        # enableTransience = true;
      };
    };
  };
}
