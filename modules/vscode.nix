{
  pkgs,
  user,
  directories,
  ...
}:

{
  imports = with directories.modules; [
    # Require fonts for vscode
    style.fonts

    direnv
  ];

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
