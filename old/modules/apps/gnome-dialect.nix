{
  pkgs,
  ...
}:

{
  imports = [
    # (mkGlobalKeybind {
    #   name = "Instant translate";
    #   binding = "<Super>d";
    #   command = "dialect --selection";
    # })
  ];

  my.packages = with pkgs; [
    # Gnome circles translator app
    dialect
  ];
}
