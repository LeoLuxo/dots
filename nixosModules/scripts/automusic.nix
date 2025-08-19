{
  pkgs,
  nixosModules,
  ...
}:

{
  imports = with nixosModules; [
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
