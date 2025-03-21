{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.ext.scripts.snip;
in
{
  options.ext.scripts.snip = {
    enable = lib.mkEnableOption "the snip script";
  };

  config = lib.mkIf cfg.enable {
    ext.desktop.keybinds."Instant screenshot" = {
      binding = "<Super>s";
      command = "snip";
    };

    ext.packages = with pkgs; [
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
