{
  lib,
  pkgs,
  directories,
  constants,
  extra-libs,
  ...
}:

let
  inherit (constants) user;
  inherit (extra-libs) mkSyncedMergedJSON mkSyncedPath;
in

{
  imports = with directories.modules; [
    # Require fonts for vscode
    fonts

    apps.direnv

    (mkSyncedMergedJSON {
      xdgPath = "Code/User/settings.json";
      cfgPath = "vscode/settings.json";
      defaultOverrides = {
        "workbench.colorTheme" = "";
      };
    })

    (mkSyncedPath {
      xdgPath = "Code/User/keybindings.json";
      cfgPath = "vscode/keybindings.json";
    })

    (mkSyncedPath {
      xdgPath = "Code/User/snippets";
      cfgPath = "vscode/snippets";
    })

    (mkSyncedPath {
      xdgPath = "Code/User/profiles";
      cfgPath = "vscode/profiles";
      excludes = [ "globalStorage" ];
    })
  ];

  defaults.apps.codeEditor = lib.mkDefault "code";

  environment.variables = {
    EDITOR = "code";
  };

  home-manager.users.${user} = {
    programs.vscode = {
      enable = true;
      # FHS is vscode but repackaged to run in a FHS environment to make plugin compatibility better
      # package = pkgs.vscode.fhs;
      package = pkgs.vscode.fhsWithPackages (
        # Add required dependecies
        ps: with ps; [
          # nix formatter
          nixfmt-rfc-style

          # Nix Language Server
          nil

          # sh formatter
          shfmt

          vscode-extensions.rust-lang.rust-analyzer
        ]
      );
    };
  };
}
