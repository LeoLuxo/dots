{
  pkgs,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = [
    ./deepl-linux-electron.nix

    # (mkGlobalKeybind {
    #   name = "Instant translate";
    #   binding = "<Super>d";
    #   command = "dialect --selection";
    # })
  ];

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      deepl-linux-electron
    ];
  };
}
