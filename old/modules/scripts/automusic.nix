{
  extraLib,
  nixosModulesOld,
  ...
}:

let
  inherit (extraLib) writeScriptWithDeps;
in

{
  imports = with nixosModulesOld; [
    apps.beets
  ];

  my.packages = [
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
}
