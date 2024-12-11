{
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkGnomeKeybind;
in

{
  imports = [
    (mkGnomeKeybind {
      name = "Instant translate";
      binding = "<Super>d";
      command = "dialect --selection";
    })
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Gnome circles translator app
      dialect
    ];
  };
}
