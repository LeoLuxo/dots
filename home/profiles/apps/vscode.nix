{ pkgs, homeProfiles, ... }:
{
  imports = [
    # Require fonts for vscode
    homeProfiles.common.fonts

    # (mkSyncedPath {
    #   xdgPath = "Code/User/settings.json";
    #   cfgPath = "vscode/settings.json";
    # })

    # (mkSyncedPath {
    #   xdgPath = "Code/User/keybindings.json";
    #   cfgPath = "vscode/keybindings.json";
    # })

    # (mkSyncedPath {
    #   xdgPath = "Code/User/snippets";
    #   cfgPath = "vscode/snippets";
    # })

    # Profiles are a bit fucky
    # (mkSyncedPath {
    #   xdgPath = "Code/User/profiles";
    #   cfgPath = "vscode/profiles";
    #   excludes = [ "globalStorage" ];
    # })
  ];

  home.sessionVariables = {
    EDITOR = "code";
  };

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
}
