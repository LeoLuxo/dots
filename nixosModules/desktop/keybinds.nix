{
  lib,
  config,
  options,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.my) mkAttrs';
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.desktop.keybinds;
in
{

  # Alias for convenience
  imports = [
    (lib.mkAliasOptionModule [ "my" "keybinds" ] [ "my" "desktop" "keybinds" ])
  ];

  options.my.desktop.keybinds = mkAttrs' "the desktop keybinds to configure" (
    { name, ... }:
    {
      binding = mkOption {
        description = "the key combination to trigger the command";
        type = types.str;
      };

      command = mkOption {
        description = "the command to execute when the keybind is triggered";
        type = types.oneOf [
          types.str
          types.path
          types.package
        ];
      };

      id = mkOption {
        description = "the identifier for the keybind, used for configuration";
        type = types.str;
        default = lib.toLower (lib.strings.sanitizeDerivationName name);
      };

      scriptName = mkOption {
        description = "the name of the script that will be created for the keybind and invoked when the keybind is triggered";
        type = types.str;
        default = "keybind-${cfg.${name}.id}";
      };
    }
  );

  config = {
    # This here is split up and ugly because of mkMerge and false infinite recursion because of `config.my`

    # Generic config
    my.packages = lib.mapAttrsToList (
      _: keybind: pkgs.writeShellScriptBin keybind.scriptName keybind.command
    ) cfg;

    # Gnome-specific config, add the keybind to dconf
    my.hm.dconf.settings = mkIf config.desktop.gnome.enable (
      lib.mkMerge (
        lib.mapAttrsToList (name: keybind: {
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [
              "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${keybind.id}/"
            ];
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${keybind.id}" = {
            inherit name;
            binding = keybind.binding;
            command = keybind.scriptName;
          };
        }) cfg
      )
    );
  };
}
