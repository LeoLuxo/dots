{
  lib,
  outputs,
  ...
}:
with lib;
with outputs.lib;

rec {
  /**
    Converts the first letter of a string to uppercase, keeping the rest unchanged

    # Example

    ```nix
    toUpperCaseFirstLetter "hello"
    =>
    "Hello"
    ```

    # Type

    ```
    toUpperCaseFirstLetter :: String -> String
    ```

    # Arguments

    string
    : The input string to transform

    # Note

    Returns empty string if input is empty. Function assumes input is a valid string.
  */
  toUpperCaseFirstLetter =
    string:
    let
      head = strings.toUpper (strings.substring 0 1 string);
      tail = strings.substring 1 (-1) string;
    in
    head + tail;

  /**
    Splits a string into words by space, dash and underscore delimiters

    # Example

    ```nix
    splitWords "hello-world_test string"
    =>
    [ "hello" "world" "test" "string" ]
    ```

    # Type

    ```
    splitWords :: String -> [String]
    ```

    # Arguments

    string
    : The input string to be split into words
  */
  splitWords =
    string:
    # builtins.split returns non-matches (as string) interleaved with the matches (as list), so we filter by string
    builtins.filter builtins.isString (
      # we split by space, dash - and underscore _
      builtins.split "[ _-]" string
    );

  /**
    Converts a string to PascalCase format by capitalizing the first letter of each word

    # Example

    ```nix
    toPascalCase "hello world"
    =>
    "HelloWorld"
    ```

    # Type

    ```
    toPascalCase :: String -> String
    ```

    # Arguments

    string
    : The input string to convert to PascalCase
  */
  toPascalCase = string: strings.concatMapStrings toUpperCaseFirstLetter (splitWords string);

  /**
    Converts a string to pascal case with spaces between words

    # Example

    ```nix
    toPascalCaseWithSpaces "hello-world_example"
    =>
    "Hello World Example"
    ```

    # Type

    ```
    toPascalCaseWithSpaces :: String -> String
    ```

    # Arguments

    string
    : The input string to convert to pascal case with spaces
  */
  toPascalCaseWithSpaces =
    string: strings.concatMapStringsSep " " toUpperCaseFirstLetter (splitWords string);

  /**
    Replaces variables in a script text with their corresponding values

    # Example

    ```nix
    replaceScriptVariables "Hello $name" { name = "World"; }
    =>
    "Hello World"
    ```

    # Type

    ```
    replaceScriptVariables :: String -> AttrSet -> String
    ```

    # Arguments

    script
    : The text containing variables to be replaced

    variables
    : An attribute set where keys are variable names and values are their replacements.
      Variables can be referenced in the script using either $name or ${name} syntax

    # Notes

    - Supports both $variable and ${variable} syntax
    - All occurrences of variables will be replaced
    - Variable names in the attribute set should not include the $ or ${} syntax
  */
  replaceScriptVariables =
    script: variables:
    let
      varNames1 = map (x: "$" + x) (attrNames variables);
      varNames2 = map (x: "\${" + x + "}") (attrNames variables);
      varValues = attrValues variables;
    in
    replaceStrings (varNames1 ++ varNames2) (varValues ++ varValues) script;
}
