{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Vscode but repackaged to run in a FHS environment
    vscode-fhs

    # nix formatter
    nixfmt-rfc-style

    # Nix Language Server
    nil

    # sh formatter
    shfmt
  ];
}
