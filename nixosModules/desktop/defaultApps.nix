{
  lib,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;
in
{
  options.ext.desktop.defaultApps = with lib2.options; {
    browser = mkNullOr "The default internet browsing app." types.str;
    notes = mkNullOr "The default note-taking app." types.str;
    communication = mkNullOr "The default communication app." types.str;
    codeEditor = mkNullOr "The default code editor." types.str;
    terminal = mkNullOr "The default terminal emulator." types.str;
    backupTerminal = mkNullOr "The backup terminal emulator." types.str;
  };
}
