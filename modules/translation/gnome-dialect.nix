{
  pkgs,
  user,
  mkGnomeKeybind,
  ...
}:

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