{
  lib,
  pkgs,
  constants,
  extra-libs,
  directories,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkSyncedJSON;
in

{
  imports = with directories.modules; [
    ./icons.nix
    ./keybinds-fix.nix
    ./disable-update-check.nix

    default-programs

    (mkSyncedJSON {
      xdgPath = "vesktop/settings.json";
      cfgPath = "vesktop/settings1.json";
    })

    (mkSyncedJSON {
      xdgPath = "vesktop/settings/settings.json";
      cfgPath = "vesktop/settings2.json";
    })

  ];

  defaultPrograms.communication = lib.mkDefault "vesktop";

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };
}
