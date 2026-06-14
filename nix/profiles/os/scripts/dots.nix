{
  lib2,
  pkgs,
  dots,
  user,
  ...
}:

{
  home-manager.users.${user} = {
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
          ''${APP_CODE_EDITOR:-''${VISUAL:-''${EDITOR:-nano}}} "${dots}"
        '';
        deps = [ pkgs.nano ];
      })
    ];

    # Add aliases
    home.shellAliases = {
      nx-edit = "edit-dots";
      nx-cd = "cd $DOTS";
      nxcd = "nx-cd";
    };
  };
}
