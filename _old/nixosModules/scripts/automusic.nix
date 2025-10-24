{
  pkgs,
  nixosModules,
  user,
  ...
}:

{
  imports = with nixosModules; [
    apps.beets
  ];

  environment.systemPackages = [
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
