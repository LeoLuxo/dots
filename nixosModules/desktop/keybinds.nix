{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.my.desktop.keybinds;
in
{
  options.my.desktop.keybinds =
    with lib2.options;
    mkAttrsSub' {
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

  config = lib.mapAttrs' (
    name: keybind:
    let
      id = lib.toLower (lib.strings.sanitizeDerivationName name);
      scriptName = "keybind-${id}";
    in
    {
      # Create an extra script for the keybind, this avoids a bunch of weird issues
      my.packages = [
        (pkgs.writeShellScriptBin scriptName keybind.command)
      ];
    }
    // (
      if config.desktop.manager.gnome.enable then
        {
          programs.dconf.enable = true;

          # Add the keybind to dconf
          my.hm.dconf.settings = {
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
          };

        }
      else
        lib.warn "No compatible desktop to create keybind for was found!" { }
    )
  ) cfg;
}
