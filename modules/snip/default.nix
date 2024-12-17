{
  pkgs,
  constants,
  extra-libs,
  directories,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkGlobalKeybind writeScriptWithDeps;
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
      (writeScriptWithDeps {
        name = "snip";
        file = ./snip.sh;
        deps = [
          gnome-screenshot
          wl-clipboard
        ];
        shell = true;
      })
    ];
  };
}
