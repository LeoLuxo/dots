{
  lib2,
  pkgs,
  dotsTodo,
  user,
  ...
}:

{
  home-manager.users.${user} = {
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

          # Open the todo in vscode / or a backup text editor
          editor=''${APP_CODE_EDITOR:-''${VISUAL:-${pkgs.gnome-text-editor}}}

          if [[ $editor = "code" ]]; then
            code "${dotsTodo}" --reuse-window
          else
            $editor "${dotsTodo}"
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
