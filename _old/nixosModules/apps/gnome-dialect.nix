{
  pkgs,
  lib,
  ...
}:

{
  imports = [
    (lib.nixos.mkKeybind {
      name = "Instant translate";
      binding = "<Super>d";
      command = "dialect --selection";
    })
  ];

  environment.systemPackages = with pkgs; [
    # Gnome circles translator app
    dialect
  ];

}
