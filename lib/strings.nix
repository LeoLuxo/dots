{ lib, ... }:

rec {
  toUpperCaseFirstLetter =
    string:
    let
      head = lib.strings.toUpper (lib.strings.substring 0 1 string);
      tail = lib.strings.substring 1 (-1) string;
    in
    head + tail;

  splitWords =
    string:
    # builtins.split returns non-matches (as string) interleaved with the matches (as list), so we filter by string
    builtins.filter builtins.isString (
      # we split by space, dash - and underscore _
      builtins.split "[ _-]" string
    );

  toPascalCase = string: lib.strings.concatMapStrings toUpperCaseFirstLetter (splitWords string);

  toPascalCaseWithSpaces =
    string: lib.strings.concatMapStringsSep " " toUpperCaseFirstLetter (splitWords string);

  replaceScriptVariables =
    script: variables:
    let
      varNames1 = map (x: "$" + x) (lib.attrNames variables);
      varNames2 = map (x: "\${" + x + "}") (lib.attrNames variables);
      varValues = lib.attrValues variables;
    in
    lib.replaceStrings (varNames1 ++ varNames2) (varValues ++ varValues) script;
}
