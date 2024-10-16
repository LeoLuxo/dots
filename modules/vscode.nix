{
  pkgs,
  user,
  directories,
  ...
}:

{
  # Require fonts for vscode
  imports = with directories.modules; [
    style.fonts
  ];

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
    ];

    home.sessionVariables = {
      EDITOR = "code";
    };
  };
}
