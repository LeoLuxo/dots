{
  lib,
  config,
  pkgs,
  lib2,
  user,
  ...
}:

let
  inherit (lib) types;
  inherit (lib2) notNullOr mkAttrs;
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
  };
}
