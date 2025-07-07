{
  lib,
  ...
}:

let
  inherit (lib) types;
  inherit (lib.options) mkOption;
in

let
  mkEntry =
    description:
    mkOption {
      inherit description;
      type = types.nullOr types.str;
      default = null;
    };
in
{
  options.my.desktop.defaultApps = {
    browser = mkEntry "The default internet browsing app.";
    notes = mkEntry "The default note-taking app.";
    communication = mkEntry "The default communication app.";
    codeEditor = mkEntry "The default code editor.";
    terminal = mkEntry "The default terminal emulator.";
    backupTerminal = mkEntry "The backup terminal emulator.";
  };
}
