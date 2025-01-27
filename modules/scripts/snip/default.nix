{
  pkgs,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib) mkGlobalKeybind writeScriptWithDeps;
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
      })
    ];
  };
}
