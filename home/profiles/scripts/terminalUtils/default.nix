{
  pkgs,
  lib2,
  ...
}:

{
  imports = [
    (lib2.hm.mkShellHistoryAlias {
      name = "please";
      command = { lastCommand }: ''sudo ${lastCommand}'';
    })
  ];

  home.packages = with pkgs; [
    # To query the filetype of files
    file

    (pkgs.writeScriptWithDeps {
      name = "size";
      file = ./size.sh;
    })

    (pkgs.writeScriptWithDeps {
      name = "cheat";
      file = ./cheat.sh;
      deps = [ curl ];
    })

    (pkgs.writeScriptWithDeps {
      name = "extract";
      file = ./extract.sh;
      deps = [
        # All the archive extractors used in the script
        gnutar
        rar
        unzip
        p7zip
        gzip
      ];
    })

    (pkgs.writeScriptWithDeps {
      name = "q";
      file = ./q.sh;
      deps = [
        # To highlight source code
        bat

        # To query the filetype of files
        file

        # To visualize images directly in the terminal
        viu

        # To visualize folders nicely
        tree
      ];
    })

    (pkgs.writeScriptWithDeps {
      name = "_qq-internals";
      file = ./qq.sh;
      deps = [ ];
    })
  ];

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
}
