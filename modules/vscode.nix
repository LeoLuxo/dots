{ pkgs, user, ... }:

{
  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # Vscode but repackaged to run in a FHS environment to make plugin compatibility better
      vscode-fhs

      # nix formatter
      nixfmt-rfc-style

      # Nix Language Server
      nil

      # sh formatter
      shfmt
    ];

    home.sessionVariables = {
      EDITOR = "code";
    };
  };
}
