{
  lib,
  pkgs,
  nixosModules,
  constants,
  extraLib,
  ...
}:

let
  inherit (constants) user;
  inherit (extraLib) mkSyncedMergedJSON mkSyncedPath;
in

{
  imports = with nixosModules; [
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

    # They are a bit fucky
    # (mkSyncedPath {
    #   xdgPath = "Code/User/profiles";
    #   cfgPath = "vscode/profiles";
    #   excludes = [ "globalStorage" ];
    # })
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
        ]
      );
    };
  };
}
