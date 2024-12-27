{
  extra-libs,
  ...
}:
let
  inherit (extra-libs) mkString;
in
{
  options.defaults = {
    apps = {
      browser = mkString;
      notes = mkString;
      communication = mkString;
      codeEditor = mkString;
      terminal = mkString;
      backupTerminal = mkString;
    };
  };
}
