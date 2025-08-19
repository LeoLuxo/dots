{
  config,
  lib,
  pkgs,
  nixosModulesOld,
  lib2,
  ...
}:

let
  inherit (lib2) mkSyncedPath;
in

{
  imports = with nixosModulesOld; [
    # Require fonts for vscode
    fonts

    apps.direnv

    (mkSyncedPath {
      xdgPath = "Code/User/settings.json";
      cfgPath = "vscode/settings.json";
    })

    (mkSyncedPath {
      xdgPath = "Code/User/keybindings.json";
      cfgPath = "vscode/keybindings.json";
    })

    (mkSyncedPath {
      xdgPath = "Code/User/snippets";
      cfgPath = "vscode/snippets";
    })

    # Profiles are a bit fucky
    # (mkSyncedPath {
    #   xdgPath = "Code/User/profiles";
    #   cfgPath = "vscode/profiles";
    #   excludes = [ "globalStorage" ];
    # })
  ];

  my.defaultApps.codeEditor = lib.mkDefault "code";

  environment.variables = {
    EDITOR = "code";
  };

  home-manager.users.${config.my.user.name} = {
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
