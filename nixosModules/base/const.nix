{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib) types;
  inherit (pkgs.lib2) notNullOr mkAttrs;
  inherit (lib.options) mkOption;
  inherit (lib.modules) mkIf;
in

let
  mkDefaultAppEntry =
    description:
    mkOption {
      inherit description;
      type = types.nullOr types.str;
      default = null;
    };

  mkPathEntry =
    args:
    mkOption {
      type = types.nullOr types.path;
      default = null;
    }
    // args;

in
{
  options.my = {

    # Default applications to use for a certain context
    defaultApps = {
      browser = mkDefaultAppEntry "The default internet browsing app.";
      notes = mkDefaultAppEntry "The default note-taking app.";
      communication = mkDefaultAppEntry "The default communication app.";
      codeEditor = mkDefaultAppEntry "The default code editor.";
      terminal = mkDefaultAppEntry "The default terminal emulator.";
      backupTerminal = mkDefaultAppEntry "The backup terminal emulator.";
    };

    # Paths to be references in this config
    paths = {
      "home" = mkPathEntry {
        description = "the default home folder; by default is set as the user's home if this nixos-config is configured as a single-user system (`/home/<user>` by default), `/root` otherwise";
        default = notNullOr config.my.user.home "/root";
      };

      "nixos" = mkPathEntry {
        description = "the nixos config folder";
        default = "/etc/nixos";
      };

      "nixosRepo" = mkPathEntry {
        description = "the working copy of this repository";
      };
    };

    # Key pairs
    keys = mkAttrs {
      description = "key pairs available on the machine and accessible to the other nixos modules";

      options = {
        public = mkOption {
          description = "the path of this pair's public key";
          type = types.path;
        };
        private = mkOption {
          description = "the path of this pair's private key";
          type = types.path;
        };
      };

      default = {
        # TODO: Move this to presets
        user = mkIf (config.my.user != null) {
          private = "${config.my.user.home}/.ssh/id_ed25519";
          public = "${config.my.user.home}/.ssh/id_ed25519.pub";
        };

        host = {
          private = "/etc/ssh/ssh_host_ed25519_key";
          public = "/etc/ssh/ssh_host_ed25519_key.pub";
        };
      };
    };

    # TODO: Add devices here with hostname/ip and syncthing id
  };
}
