{
  pkgs,
  config,
  constants,
  extraLib,
  ...
}:

let

  inherit (extraLib) mkShellHistoryAlias writeScriptWithDeps;
in

{
  imports = [
    (mkShellHistoryAlias {
      name = "please";
      command = { lastCommand }: ''sudo ${lastCommand}'';
    })
  ];

  my.packages = with pkgs; [
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

    (writeScriptWithDeps {
      name = "_qq-internals";
      file = ./qq.sh;
      deps = [ ];
    })
  ];

  home-manager.users.${config.my.user.name} = {
    # Add aliases
    home.shellAliases = {
      pls = "please";

      l = "ls -Fhsla";

      c = "$EDITOR .";

      "." = "q .";

      "qq" = ''eval "$(_qq-internals)"'';

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
  };

}
