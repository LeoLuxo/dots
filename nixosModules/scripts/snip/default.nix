{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.scripts.snip;
in
{
  options.my.scripts.snip = {
    enable = lib.mkEnableOption "the snip script";
  };

  config = lib.mkIf cfg.enable {
    my.desktop.keybinds."Instant screenshot" = {
      binding = "<Super>s";
      command = "snip";
    };

    my.packages = with pkgs; [
      (writeScriptWithDeps {
        name = "snip";
        file = ./snip.sh;
        deps = [
          gnome-screenshot
          wl-clipboard
        ];
      })
    ];

  };
}
