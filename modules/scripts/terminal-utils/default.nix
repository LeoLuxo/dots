{
  config,
  lib,
  pkgs,

  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable writeScriptWithDeps;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {

    shell = {
      aliases = {
        pls = "please";

        l = "ls -Fhsla";

        c = "$EDITOR .";

        "." = "q";
        "qq" = "cd $(cat /tmp/Q_LAST_DIR)";

        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "....." = "cd ../../../..";
        "......" = "cd ../../../../..";
        "......." = "cd ../../../../../..";
        "........" = "cd ../../../../../../..";
        "........." = "cd ../../../../../../../..";
        ".........." = "cd ../../../../../../../../..";
      };

      aliasesWithHistory = {
        "please" = { lastCommand }: ''sudo ${lastCommand}'';
      };
    };

    home-manager.users.${constants.user} = {
      home.packages = with pkgs; [
        # To query the filetype of files
        file

        (writeScriptWithDeps {
          name = "size";
          file = ./size.sh;
        })

        (writeScriptWithDeps {
          name = "cheat";
          file = ./cheat.sh;
          deps = [ curl ];
        })

        (writeScriptWithDeps {
          name = "extract";
          file = ./extract.sh;
          # All the archive extractors used in the script
          deps = [
            gnutar
            rar
            unzip
            p7zip
            gzip
          ];
        })

        (writeScriptWithDeps {
          name = "q";
          file = ./q.sh;
          deps = [
            # To highlight source code
            highlight

            # To query the filetype of files
            file

            # To visualize images directly in the terminal
            viu

            # To visualize folders nicely
            tree
          ];
        })
      ];
    };
  };
}
