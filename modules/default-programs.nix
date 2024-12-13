{
  extra-libs,
  ...
}:
let
  inherit (extra-libs) mkString;
in
{
  options.defaultPrograms = {
    browser = mkString;
    notes = mkString;
    communication = mkString;
    codeEditor = mkString;
  };
}
