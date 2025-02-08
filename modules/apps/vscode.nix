{
  config,
  lib,
  pkgs,

  constants,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {

    # Require fonts for vscode
    desktop.fonts.enable = true;

    apps.direnv.enable = true;

    syncedPaths = {
      "vscode/settings.json" = {
        xdgPath = "Code/User/settings.json";
        type = "json";
        overrides = {
          "workbench.colorTheme" = "";
        };
      };

      "vscode/keybindings.json" = {
        xdgPath = "Code/User/keybindings.json";
      };

      "vscode/snippets" = {
        xdgPath = "Code/User/snippets";
      };

      # Profiles are a bit fucky
      # "vscode/profiles" = {
      #   xdgPath = "Code/User/profiles";
      #   excludes = [ "globalStorage" ];
      # };
    };

    defaults.apps.codeEditor = lib.mkDefault "code";

    environment.variables = {
      EDITOR = "code";
    };

    home-manager.users.${constants.user} = {
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
  };
}
