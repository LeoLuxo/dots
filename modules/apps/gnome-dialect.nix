{
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkGlobalKeybind;
in

{
  imports = [
    (mkGlobalKeybind {
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
