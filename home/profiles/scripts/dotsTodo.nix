{
  lib2,
  pkgs,
  host,
  ...
}:

let
  variables = {
    DOTS_TODO = host.dotsTodo;
  };
in
{
  imports = [
    (lib2.hm.mkGlobalKeybind {
      name = "Open dots-todo";
      binding = "<Super>F10";
      command = "dots-todo";
    })
  ];

  home.sessionVariables = variables;

  home.packages = [
    (pkgs.writeScriptWithDeps {
      name = "dots-todo";
      text = ''
        #!/usr/bin/env bash

        # Open the todo in vscode/text editor
        if [[ $EDITOR = "code" ]]; then
          echo code "${variables.DOTS_TODO}" --reuse-window
        else
          $EDITOR "${variables.DOTS_TODO}"
        fi
      '';
    })
  ];

  # Add aliases
  home.shellAliases = {
    nx-todo = "dots-todo";
  };
}
