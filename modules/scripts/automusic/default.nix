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
      name = "automusic";

      deps = [
        pkgs.beets

        # Dependencies of lrclib-fetch
        pkgs.ffmpeg
        pkgs.jq

        (pkgs.python3.withPackages (python-pkgs: [
          # Dependencies of lrcput
          python-pkgs.mutagen
          python-pkgs.eyed3
          python-pkgs.tqdm

          # Extra plugins for beets
          # python-pkgs.beets-filetote
        ]))
      ];

      text = ''
        #!/usr/bin/env bash

        # # temp dir stuff copied from https://stackoverflow.com/questions/4632028/how-to-create-a-temporary-directory

        # # create temp directory
        # WORK_DIR=mktemp -d

        # # check if tmp dir was created
        # if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
        # 	echo "Could not create temp dir"
        # 	exit 1
        # fi

        # echo "Created temp working directory $WORK_DIR"

        # # deletes the temp directory
        # function cleanup {
        # 	rm -rf "$WORK_DIR"
        # 	echo "Deleted temp working directory $WORK_DIR"
        # }

        # # register the cleanup function to be called on the EXIT signal
        # trap cleanup EXIT


        beet import --config "${./beets-config.yaml}" --group-albums $1


        # source "${./lrclib-fetch.sh}" --hide-lyrics $1
        # python3 "${./lrcput.py}" -R -d $1
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
