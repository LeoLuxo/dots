{
  pkgs,
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

        deps = [
          # Dependencies of lrclib-fetch
          pkgs.ffmpeg
          pkgs.jq

          (pkgs.python3.withPackages (python-pkgs: [
            # Dependencies of lrcput
            python-pkgs.mutagen
            python-pkgs.eyed3
            python-pkgs.tqdm
          ]))
        ];

        text = ''
          #!/usr/bin/env bash
          beet import --group-albums "$1"
        '';
      })
    ];
  };
}
