{
  inputs,
  constants,
  ...
}:

let
  inherit (constants) nixosRepoPath system;
  inherit (inputs.nixpkgs) lib;
  inherit (lib)
    strings
    attrsets
    filesystem
    throwIf
    lists
    ;
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in

rec {
  # Capitalize first letter
  toUpperCaseFirstLetter =
    string:
    let
      head = strings.toUpper (strings.substring 0 1 string);
      tail = strings.substring 1 (-1) string;
    in
    head + tail;

  # Split words around space, dash - and underscore _
  splitWords =
    string:
    # builtins.split returns non-matches (as string) interleaved with the matches (as list), so we filter by string
    builtins.filter builtins.isString (
      # we split by space, dash - and underscore _
      builtins.split "[ _-]" string
    );

  # Convert a string to PascalCase
  toPascalCase = string: strings.concatMapStrings toUpperCaseFirstLetter (splitWords string);

  # Convert a string to PascalCase with spaces in between words
  toPascalCaseWithSpaces =
    string: strings.concatMapStringsSep " " toUpperCaseFirstLetter (splitWords string);

  # Replace variables in place in the script text
  replaceScriptVariables =
    script: variables:
    let
      varNames1 = lists.map (x: "$" + x) (attrsets.attrNames variables);
      varNames2 = lists.map (x: "\${" + x + "}") (attrsets.attrNames variables);
      varValues = attrsets.attrValues variables;
    in
    strings.replaceStrings (varNames1 ++ varNames2) (varValues ++ varValues) script;

  # Options shortcut for a string option
  mkEmptyString = lib.options.mkOption {
    type = lib.types.str;
    default = "";
  };

  # Options shortcut for a lines option
  mkEmptyLines = lib.options.mkOption {
    type = lib.types.lines;
    default = "";
  };

  # Options shortcut for a boolean option with default of false
  mkBoolDefaultFalse = lib.options.mkOption {
    type = lib.types.bool;
    default = false;
  };

  # Options shortcut for a boolean option with default of true
  mkBoolDefaultTrue = lib.options.mkOption {
    type = lib.types.bool;
    default = true;
  };

}
