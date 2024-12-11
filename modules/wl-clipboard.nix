{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      wl-clipboard
    ];

    home.shellAliases = {
      copy = "wl-copy";
      paste = "wl-paste";
    };
  };
}
