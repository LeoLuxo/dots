{
  pkgs,
  user,
  scriptBin,
  mkGnomeKeybind,
  ...
}:
{
  imports = [
    (mkGnomeKeybind {
      name = "Instant screenshot";
      binding = "<Super>s";
      command = "snip";
    })
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Not putting these deps in the script because I don't want to wait to screenshot if they're missing
      # gnome-screenshot
      # wl-clipboard

      # The script
      (scriptBin.snip {
        deps = [
          gnome-screenshot
          wl-clipboard
        ];
        shell = true;
      })
    ];
  };
}
