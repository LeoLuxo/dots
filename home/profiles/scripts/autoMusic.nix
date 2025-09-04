{
  pkgs,
  homeProfiles,
  ...
}:

{
  imports = [
    homeProfiles.apps.beets
  ];

  home.packages = [
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
