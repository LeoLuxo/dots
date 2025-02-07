{
  lib,
  extraLib,
  ...
}:
let
  inherit (lib) types;
  inherit (extraLib) mkNullOr;
in
{
  options = {
    browser = mkNullOr types.str;
    notes = mkNullOr types.str;
    communication = mkNullOr types.str;
    codeEditor = mkNullOr types.str;
    terminal = mkNullOr types.str;
    backupTerminal = mkNullOr types.str;
  };
}
