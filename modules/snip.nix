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
