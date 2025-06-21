{
  lib,
  config,
  ...
}:

let
  cfg = config.my.shell.prompt.starship;
in
{
  options.my.shell.prompt.starship = {
    enable = lib.mkEnableOption "starship shell prompt";
  };

  config = lib.mkIf cfg.enable {
    my.hm = {
      programs.starship = {
        enable = true;

        # enableTransience = true;
      };
    };
  };
}
