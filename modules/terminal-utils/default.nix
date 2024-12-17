{
  pkgs,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkShellHistoryAlias writeScriptWithDeps;
in

{
  imports = [
    (mkShellHistoryAlias {
      name = "please";
      command = { lastCommand }: ''sudo ${lastCommand}'';
    })
  ];

  home-manager.users.${user} = {
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

    # Add aliases
    home.shellAliases = {
      pls = "please";

      l = "ls -Fhsla";

      "." = "q";

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
