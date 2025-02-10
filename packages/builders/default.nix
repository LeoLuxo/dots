{
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};

rec {

  /**
    Creates a script with optional dependencies in PATH, variable replacements, and privilege elevation.

    # Example

    ```nix
    writeScriptWithDeps {
      name = "my-script";
      text = "echo Hello World";
      deps = [ pkgs.curl pkgs.jq ];
      bashShebang = true;
    }
    =>
    /nix/store/...-my-script # Executable with curl and jq in PATH
    ```

    # Type

    ```
    writeScriptWithDeps :: {
      name :: String,
      file :: Path | Null,
      text :: String | Null,
      deps :: [Package],
      bashShebang :: Bool,
      binFolder :: Bool,
      replaceVariables :: AttrSet,
      elevate :: Bool
    } -> Package
    ```

    # Arguments

    name
    : Name of the generated script

    file
    : Optional path to script file to read from

    text
    : Script content as string. If file is provided, reads from file instead

    deps
    : List of package dependencies to add to PATH

    bashShebang
    : Whether to add a bash shebang or not

    binFolder
    : Whether to create a /bin folder with the script. If false, creates standalone script

    replaceVariables
    : Attribute set of variables to replace in script text

    elevate
    : Whether to run script with sudo
  */
  writeScriptWithDeps =
    {
      name,
      file ? null,
      text ? builtins.readFile file,
      deps ? [ ],
      bashShebang ? false,
      binFolder ? true,
      replaceVariables ? { },
      elevate ? false,
    }:
    let
      scriptTextPreVars = throwIf (text == null) "script needs text" text;
      scriptText = replaceScriptVariables scriptTextPreVars replaceVariables;

      # https://nixos.org/manual/nixpkgs/unstable/#trivial-builder-text-writing
      innerBuilder = if bashShebang then pkgs.writeShellScript else pkgs.writeScript;
      outerBuilder = if binFolder then pkgs.writeShellScriptBin else pkgs.writeShellScript;

      # Using sudo to elevate the script
      elevation = if elevate then ''sudo'' else "";
    in
    outerBuilder name ''
      for i in ${strings.concatStringsSep " " deps}; do
        export PATH="$i/bin:$PATH"
      done

      exec ${elevation} ${innerBuilder "${name}-no-deps" scriptText} $@
    '';

  /**
    Creates a Nushell script with optional dependencies and execution settings.

    # Example

    ```nix
    writeNushellScript {
      name = "my-script";
      text = "echo 'Hello World'";
      deps = [ pkgs.curl ];
      elevate = true;
    }
    ```

    # Type

    ```
    writeNushellScript :: AttrSet -> Derivation
    ```

    # Arguments

    name
    : The name of the script to create

    file
    : Optional path to a Nushell script file. Mutually exclusive with `text`

    text
    : Optional string containing the script content. Mutually exclusive with `file`

    deps
    : List of package dependencies required by the script. Defaults to empty list

    elevate
    : Whether the script should be run with elevated privileges. Defaults to false

    binFolder
    : Whether to create a bin folder for the script. Defaults to true

    # Notes

    - Either `file` or `text` must be provided, but not both
    - Uses `writeScriptWithDeps` internally with Nushell-specific configuration
    - Will automatically include Nushell as a dependency
  */
  writeNushellScript =
    {
      name,
      file ? null,
      text ? null,
      deps ? [ ],
      elevate ? false,
      binFolder ? true,
    }@args:
    writeScriptWithDeps (
      args
      // {
        bashShebang = false;
        text =
          if file == null then
            ''
              #!${pkgs.nushell}/bin/nu
              ${throwIf (text == null) "script needs text" text}
            ''
          else
            ''
              #!${pkgs.bash}/bin/bash
              ${pkgs.nushell}/bin/nu ${file}
            '';
      }
    );

  /**
    Creates a desktop entry (`.desktop` file) with optional privilege elevation support

    # Example

    ```nix
    mkDesktopItem {
      package = pkgs.firefox;
      categories = [ "Network" "WebBrowser" ];
      icon = "firefox";
      elevate = false;
    }
    ```

    # Type

    ```
    mkDesktopItem :: AttrSet -> Derivation
    ```

    # Arguments

    package
    : The package containing the executable (optional)

    name
    : The name of the desktop entry, defaults to package name/pname

    desktopName
    : The display name shown in the menu, defaults to PascalCase with spaces of name

    exec
    : The command to execute, defaults to "${package}/bin/${name}"

    icon
    : The icon name or path (optional)

    keywords
    : List of search keywords, defaults to [name]

    categories
    : List of menu categories where entry should appear

    elevate
    : Whether to run the command with elevated privileges using pkexec, defaults to false

    # Notes

    - When `elevate` is true, creates a wrapper script to handle environment variables with pkexec
    - Automatically handles desktop file generation and installation
    - Uses standard XDG desktop entry specification
  */
  mkDesktopItem =
    {
      package ? null,
      name ? package.name or package.pname,
      desktopName ? toPascalCaseWithSpaces name,
      exec ? "${package}/bin/${name}",
      icon ? null,
      keywords ? [ name ],
      categories ? [ ],
      elevate ? false,
    }:
    let
      # Using pkexec to elevate the script using the GUI-sudo-thing
      wrappedExec =
        if elevate then
          # Need to create an entire wrapped script because gnome complain about $ in the Exec field
          "${
            (writeScriptWithDeps {
              name = "${name}-desktop-icon-wrapper";
              text = ''pkexec env XAUTHORITY=$XAUTHORITY DISPLAY=$DISPLAY WAYLAND_DISPLAY=$WAYLAND_DISPLAY PATH=$PATH ${exec}'';
            })
          }/bin/${name}-desktop-icon-wrapper"
        else
          exec;

      desktopItemPackage =
        {
          stdenv,
          makeDesktopItem,
          copyDesktopItems,
        }:
        stdenv.mkDerivation (finalAttrs: {
          pname = "${name}-desktop-icon";
          version = "0.0.0";
          dontUnpack = true;
          nativeBuildInputs = [ copyDesktopItems ];
          desktopItems = (
            makeDesktopItem {
              inherit
                name
                desktopName
                icon
                keywords
                categories
                ;
              exec = wrappedExec;
            }
          );
        });
    in
    (pkgs.callPackage desktopItemPackage { });
}
