{
  extraLib,
  ...
}:
let
  inherit (extraLib) mkEmptyString;
in
{
  options.defaults = {
    apps = {
      browser = mkEmptyString;
      notes = mkEmptyString;
      communication = mkEmptyString;
      codeEditor = mkEmptyString;
      terminal = mkEmptyString;
      backupTerminal = mkEmptyString;
    };
  };
}
