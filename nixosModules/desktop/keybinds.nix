{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.my) enabled mkAttrs' mkSmartMerge;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.modules) mkIf;

  cfg = config.my.desktop.keybinds;
in
{
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
        description = "the script name for the keybind, used for configuration";
        type = types.str;
        default = cfg.${name}.id;
      };
    }
  );

  # config = mkSmartMerge [ "my" "desktop" "keybinds" ] (
  #   lib.flatten (
  #     lib.mapAttrsToList (
  #       name: keybind:
  #       let
  #         id = lib.toLower (lib.strings.sanitizeDerivationName name);
  #         scriptName = "keybind-${id}";
  #       in
  #       [
  #         # Generic config
  #         {
  #           # Create an extra script for the keybind, this avoids a bunch of weird issues
  #           # my.packages = [
  #           #   (pkgs.writeShellScriptBin scriptName keybind.command)
  #           # ];
  #         }

  #         # Gnome-specific config
  #         # (lib.mkIf config.my.desktop.manager.gnome.enable {
  #         # programs.dconf.enable = true;

  #         # Add the keybind to dconf
  #         # my.hm.dconf.settings = {
  #         #   "org/gnome/settings-daemon/plugins/media-keys" = {
  #         #     custom-keybindings = [
  #         #       "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}/"
  #         #     ];
  #         #   };

  #         #   "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}" = {
  #         #     inherit name;
  #         #     binding = keybind.binding;
  #         #     command = scriptName;
  #         #   };
  #         # };
  #         # })
  #       ]

  #     ) cfg
  #   )
  # );
}
