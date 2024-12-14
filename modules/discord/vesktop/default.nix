{
  lib,
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkSyncedJSON quickPatch;
in

{
  imports = [
    ./icons.nix
    ./keybinds-fix.nix
    # ./disable-update-check.nix

    (quickPatch {
      package = "vesktop";
      patches = [ ./disable_update_checking.patch ];
    })

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
      (vesktop.override { withSystemVencord = true; })
    ];
  };
}
