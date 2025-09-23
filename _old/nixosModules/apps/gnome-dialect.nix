{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Gnome circles translator app
    dialect
  ];

  my.keybinds."Instant translate" = {
    binding = "<Super>d";
    command = "dialect --selection";
  };
}
