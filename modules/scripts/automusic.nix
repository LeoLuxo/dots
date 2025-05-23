{
  constants,
  extraLib,
  nixosModules,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib) writeScriptWithDeps;
in

{
  imports = with nixosModules; [
    apps.beets
  ];

  home-manager.users.${user} = {
    home.packages = [
      (writeScriptWithDeps {
        name = "automusic";

        deps = [ ];

        text = ''
          #!/usr/bin/env bash
          beet import --group-albums ~/downloads
          beet fetchartist
        '';
      })
    ];
  };
}
