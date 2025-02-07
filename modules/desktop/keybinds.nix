{
  cfg,
  lib,
  extraLib,
  constants,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) options types strings;
  inherit (extraLib) mkAttrsOfSubmodule;
in
{
  options = {
    keybinds = mkAttrsOfSubmodule {
      binding = options.mkOption {
        type = types.str;
      };

      command = options.mkOption {
        type = types.oneOf [
          types.str
          types.path
          types.package
        ];
      };
    };
  };

  config = lib.mapAttrs' (
    name: keybind:
    let
      id = strings.toLower (strings.sanitizeDerivationName name);
      scriptName = "keybind-${id}";
    in
    {
      programs.dconf.enable = true;

      home-manager.users.${constants.user} = {
        # Create an extra script for the keybind, this avoids a bunch of weird issues
        home.packages = [
          (pkgs.writeShellScriptBin scriptName keybind.command)
        ];

        # Add the keybind to dconf
        dconf.settings =
          if config.desktop.gnome.enable then
            {
              "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}/"
                ];
              };

              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}" = {
                inherit name;
                binding = keybind.binding;
                command = scriptName;
              };
            }
          else
            lib.warn "No compatible desktop to create keybind for was found!" { };
      };
    }
  ) cfg.keybinds;
}
