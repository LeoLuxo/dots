{
  pkgs,
  ...
}:

{

  home.packages = [
    (pkgs.writeScriptWithDeps {
      name = "beet";

      deps = [
        (pkgs.beets.override {
          pluginOverrides = {
            # fetchartist = {
            #   enable = true;
            #   propagatedBuildInputs = [ (pkgs.callPackage ./beets-fetchartist.nix { }) ];
            # };
          };
        })
      ];

      text = ''
        #!/usr/bin/env bash
        beet --config "${./beetsConfig.yaml}" "$@"
      '';
    })

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
