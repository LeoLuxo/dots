{
  pkgs,
  constants,
  extra-libs,
  directories,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkGlobalKeybind;
in

{
  imports = [
    (mkGlobalKeybind {
      name = "Instant screenshot";
      binding = "<Super>s";
      command = "snip";
    })
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      (directories.scriptBin.snip {
        deps = [
          gnome-screenshot
          wl-clipboard
        ];
        shell = true;
      })
    ];
  };
}
