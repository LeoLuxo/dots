{
  pkgs,
  user,
  mkSyncedJSON,
  ...
}:
{
  imports = [
    ./icons.nix
    ./keybinds-fix.nix

    (mkSyncedJSON {
      srcPath = ./settings1.json;
      xdgPath = "vesktop/settings.json";
    })
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Discord fork that fixes streaming issues on linux
      vesktop
    ];
  };
}
