{
  lib2,
  pkgs,
  dotsTodo,
  ...
}:

{
  hm = {
    imports = [
      (lib2.hm.mkKeybind {
        name = "Open dots-todo";
        binding = "<Super>F10";
        command = "dots-todo";
      })
    ];

    home.sessionVariables = {
      DOTS_TODO = dotsTodo;
    };

    home.packages = [
      (pkgs.writeScriptWithDeps {
        name = "dots-todo";
        text = ''
          #!/usr/bin/env bash

          # Open the todo in vscode/text editor
          if [[ $EDITOR = "code" ]]; then
            echo code "${dotsTodo}" --reuse-window
          else
            $EDITOR "${dotsTodo}"
          fi
        '';
      })
    ];

    # Add aliases
    home.shellAliases = {
      nx-todo = "dots-todo";
    };
  };
}
