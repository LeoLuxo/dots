{
  pkgs,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib) mkGlobalKeybind;
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
