{
  cfg,
  lib,
  pkgs,
  constants,
  extraLibs,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLibs) mkEnable;
in

{
  imports = [
    ./deepl-linux-electron.nix
  ];

  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        deepl-linux-electron
      ];

      # Add dark mode css
      xdg.configFile."Deepl-Linux-Electron/user_theme.css".text = ''
        html {
          filter: invert(90%) hue-rotate(180deg) brightness(110%) contrast(110%);
          background: white;
        }
      '';
    };
  };
}
