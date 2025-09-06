{
  lib2,
  pkgs,
  host,
  ...
}:

let
  variables = {
    DOTS = host.dots;
  };
in
{
  imports = [
    (lib2.hm.mkGlobalKeybind {
      name = "Open edit-dots";
      binding = "<Super>F9";
      command = "edit-dots";
    })
  ];

  home.sessionVariables = variables;

  home.packages = [
    (pkgs.writeScriptWithDeps {
      name = "edit-dots";
      text = ''
        #!/usr/bin/env bash

        # Open the config repo in vscode/text editor
        $EDITOR "${variables.DOTS}"
      '';
    })
  ];

  # Add aliases
  home.shellAliases = {
    nx-edit = "edit-dots";
    nx-cd = "cd $NX_DOTS";
    nxcd = "nx-cd";
  };
}
