{
  constants,
  extraLib,
  nixosModulesOld,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib) writeScriptWithDeps;
in

{
  imports = with nixosModulesOld; [
    apps.beets
  ];

  home-manager.users.${user} = {
    home.packages = [
      (writeScriptWithDeps {
        name = "automusic";

        deps = [ ];

        text = ''
          #!/usr/bin/env bash
          beet import /stuff/media/downloads -m
          # beet fetchartist
        '';
      })
    ];
  };
}
