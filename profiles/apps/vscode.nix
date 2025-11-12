{
  lib,
  pkgs,
  lib2,
  user,
  ...
}:

let
  inherit (lib2.nixos) mkSyncedPath;
in

{
# TODO: `c` command opens nano instead of vscode

  imports = [
    (mkSyncedPath {
      target = "~/.config/Code/User/settings.json";
      syncName = "vscode/settings.json";
    })

    (mkSyncedPath {
      target = "~/.config/Code/User/keybindings.json";
      syncName = "vscode/keybindings.json";
    })

    (mkSyncedPath {
      target = "~/.config/Code/User/snippets";
      syncName = "vscode/snippets";
    })

    # Profiles are a bit fucky
    # (mkSyncedPath {
    #   target = "~/.config/Code/User/profiles";
    #   syncName = "vscode/profiles";
    #   excludes = [ "globalStorage" ];
    # })
  ];

  environment.variables = {
    VISUAL = "code";
    APP_CODE_EDITOR = lib.mkDefault "code";
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
