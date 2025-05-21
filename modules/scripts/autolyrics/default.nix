{
  pkgs,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib) writeScriptWithDeps;
in

let
  package = (
    writeScriptWithDeps {
      name = "autolyrics";
      deps = [
        pkgs.ffmpeg
        pkgs.jq

        (pkgs.python3.withPackages (python-pkgs: [
          python-pkgs.mutagen
          python-pkgs.eyed3
          python-pkgs.tqdm
        ]))
      ];
      text = ''
        #!/usr/bin/env bash

        source "${./lrclib-fetch.sh}" --hide-lyrics $1
        python3 "${./lrcput.py}" -R -d $1
      '';
    }
  );
in
{
  home-manager.users.${user} = {
    home.packages = [
      package
    ];
  };
}
