{
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkSyncedJSON;
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };

  imports = [
    ./icons.nix
    ./keybinds-fix.nix

    (mkSyncedJSON {
      syncPath = "vesktop/settings1.json";
      xdgPath = "vesktop/settings.json";
    })

    (mkSyncedJSON {
      syncPath = "vesktop/settings2.json";
      xdgPath = "vesktop/settings/settings.json";
    })
  ];
}
