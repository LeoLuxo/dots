{
  pkgs,
  nixosModulesOld,
  ...
}:

{
  imports = with nixosModulesOld; [
    apps.beets
  ];

  my.packages = [
    (pkgs.writeScriptWithDeps {
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
