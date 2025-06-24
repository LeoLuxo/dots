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
    mkAttrsSub' "keybinds to create for the desktop environment" {
      binding = mkOpt' "the keyboard binding for this keybind" types.str;

      command = mkOpt' "the command for this keybind" (
        types.oneOf [
          types.str
          types.path
          types.package
        ]
      );

    };

  config = lib2.mkMergeTopLevel [ "programs" "environment" "home-manager" ] (
    lib.mapAttrsToList (
      name: keybind:

      # if config.desktop.manager.gnome.enable then
      if true then # TODO
        let
          id = lib.toLower (lib.strings.sanitizeDerivationName name);
          scriptName = "keybind-${id}";
        in
        {
          programs.dconf.enable = true;

          # Create an extra script for the keybind, this avoids a bunch of weird issues
          environment.systemPackages = [
            (pkgs.writeShellScriptBin scriptName keybind.command)
          ];

          # Add the keybind to dconf
          home-manager.users.${config.my.system.user.name}.dconf.settings = {
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
    ) cfg
  );

  # config = lib.mapAttrs' (
  #   name: keybind:
  #   let
  #     id = lib.toLower (lib.strings.sanitizeDerivationName name);
  #     scriptName = "keybind-${id}";
  #   in
  #   {
  #     # Create an extra script for the keybind, this avoids a bunch of weird issues
  #     my.packages = [
  #       (pkgs.writeShellScriptBin scriptName keybind.command)
  #     ];
  #   }
  #   // (
  #     if config.desktop.manager.gnome.enable then
  #       {
  #         programs.dconf.enable = true;

  #         # Add the keybind to dconf
  #         my.hm.dconf.settings = {
  #           "org/gnome/settings-daemon/plugins/media-keys" = {
  #             custom-keybindings = [
  #               "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}/"
  #             ];
  #           };

  #           "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/${id}" = {
  #             inherit name;
  #             binding = keybind.binding;
  #             command = scriptName;
  #           };
  #         };

  #       }
  #     else
  #       lib.warn "No compatible desktop to create keybind for was found!" { }
  #   )
  # ) cfg;
}
