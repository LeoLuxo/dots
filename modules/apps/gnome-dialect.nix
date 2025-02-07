{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  config = {
    desktop.keybinds."Instant translate" = {
      binding = "<Super>d";
      command = "dialect --selection";
    };

    home-manager.users.${user} = {
      home.packages = with pkgs; [
        # Gnome circles translator app
        dialect
      ];
    };
  };
}
