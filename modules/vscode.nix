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

    direnv

    default-programs
  ];

  defaultPrograms.codeEditor = lib.mkDefault "code";

  environment.variables = {
    EDITOR = "code";
  };

  home-manager.users.${user} = {
    programs.vscode = {
      enable = true;
      # Vscode but repackaged to run in a FHS environment to make plugin compatibility better
      package = pkgs.vscode.fhs;
    };

    home.packages = with pkgs; [
      # nix formatter
      nixfmt-rfc-style

      # Nix Language Server
      nil

      # sh formatter
      shfmt

      #
      vscode-extensions.rust-lang.rust-analyzer
    ];
  };
}
