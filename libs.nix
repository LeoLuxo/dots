{
  lib,
  pkgs,
}:

let
  inherit (lib)
    strings
    attrsets
    filesystem
    throwIf
    lists
    debug
    ;
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

  # Write a script just like pkgs.writeShellScriptBin and pkgs.writeScriptBin, but optionally add some dependencies.
  # Is automatically wrapped in another script with the deps on the PATH.
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

  # Write a nushell script akin to writeScriptWithDeps
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

  # Sanitize a path so that it doesn't cause problems in the nix store
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = strings.sanitizeDerivationName (builtins.baseNameOf path);
    };

  importModules =
    {
      dir,
      namespace ? [ ],
    }:
    # Returns a nixos module that imports all of the sub-modules
    moduleInputs: {
      imports = debug.traceValSeq (
        lists.flatten (
          # Recursively go through the files and directories from the given dir
          attrsets.mapAttrsToList (
            fileName: type:
            let
              path = dir + "/${fileName}";
            in

            if type == "directory" then
              # Recursively descend into the dir
              importModules {
                # Make sure to append the dir name to the path
                dir = path;
                # And add it to the namespace
                namespace = namespace ++ [ fileName ];
              }

            else if type == "regular" then
              let
                # Inputs for the module, which also includes:
                # - namespace
                # - cfg, which is a shorcut for `config.n1.n2.(...).ni` for each `n` in namespace
                inputs = moduleInputs // {
                  inherit namespace;
                  cfg = lib.lists.foldl (cfg: name: cfg.${name}) moduleInputs.config namespace;
                };

                # Import the module and provide the inputs
                importedModule = (import path) (debug.traceValSeq inputs);

                # Copy over imports and config, but modify options
                modifiedModule = (
                  debug.traceValSeq {
                    imports = importedModule.imports or [ ];
                    config = importedModule.config or { };

                    # Modify the options field of the module to prefix it with the namespace:
                    # so `options.myOption = mkOption {...}` => `options.n1.n2.(...).ni.myOption = mkOption {...}` for each `n` in namespace
                    options = lib.lists.foldr (name: opt: { ${name} = opt; }) (importedModule.options or { }) namespace;
                  }
                );
              in
              modifiedModule

            else
              # Ignore incompatible files, but emit a warning
              lib.warn "Found bad file '${fileName}' of type '${type}' while loading modules" [ ]

          ) (builtins.readDir dir)
        )
      );
    };

  # mkNullOr =
  #   type:
  #   lib.options.mkOption {
  #     type = lib.types.nullOr type;
  #     default = null;
  #   };

  # # Options shortcut for a string option
  # mkEmptyString = lib.options.mkOption {
  #   type = lib.types.str;
  #   default = "";
  # };

  # # Options shortcut for a lines option
  # mkEmptyLines = lib.options.mkOption {
  #   type = lib.types.lines;
  #   default = "";
  # };

  # # Options shortcut for a boolean option with default of false
  # mkBoolDefaultFalse = lib.options.mkOption {
  #   type = lib.types.bool;
  #   default = false;
  # };

  # # Options shortcut for a boolean option with default of true
  # mkBoolDefaultTrue = lib.options.mkOption {
  #   type = lib.types.bool;
  #   default = true;
  # };

  mkEnable = lib.options.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
  };

  # Options shortcut for a submodule
  mkSubmodule =
    options:
    lib.options.mkOption {
      type = lib.types.submodule {
        inherit options;
      };
      default = { };
    };

  mkAttrsOfSubmodule =
    options:
    lib.options.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          inherit options;
        }
      );
      default = { };
    };

}
