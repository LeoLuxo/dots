{
  lib2,
  pkgs,
  dots,
  ...
}:

{
  hm = {
    imports = [
      (lib2.hm.mkKeybind {
        name = "Open edit-dots";
        binding = "<Super>F9";
        command = "edit-dots";
      })
    ];

    home.sessionVariables = {
      DOTS = dots;
    };

    home.packages = [
      (pkgs.writeScriptWithDeps {
        name = "edit-dots";
        text = ''
          #!/usr/bin/env bash

          # Open the config repo in vscode/text editor
          $EDITOR "${dots}"
        '';
      })
    ];

    # Add aliases
    home.shellAliases = {
      nx-edit = "edit-dots";
      nx-cd = "cd $NX_DOTS";
      nxcd = "nx-cd";
    };
  };
}
