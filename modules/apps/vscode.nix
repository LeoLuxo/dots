{
  lib,
  pkgs,
  directories,
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  imports = with directories.modules; [
    # Require fonts for vscode
    fonts

    apps.direnv
  ];

  defaultPrograms.codeEditor = lib.mkDefault "code";

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
