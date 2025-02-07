{
  extraLib,
  ...
}:
let
  inherit (extraLib) mkNullOrString;
in
{
  options.defaultApps = {
    browser = mkNullOrString;
    notes = mkNullOrString;
    communication = mkNullOrString;
    codeEditor = mkNullOrString;
    terminal = mkNullOrString;
    backupTerminal = mkNullOrString;
  };
}
