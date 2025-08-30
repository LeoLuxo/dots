{ lib }:
let
  inherit (lib) types;
in

rec {
  enabled = {
    enable = true;
  };

  disabled = {
    enable = false;
  };

  notNullOr = value: fallback: if value != null then value else fallback;

  writeFile =
    {
      path,
      text,
      force ? false,
    }:
    ''
      ${if force then "rm -f ${path}" else ""}

      mkdir --parents "$(dirname "${path}")"
      cat >"${path}" <<-EOF
      ${text}
      EOF
    '';

  # Apply one or more patches to a package without having to create an entire overlay for it
  mkQuickPatch =
    { package, patches }:
    { ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          ${package} = prev.${package}.overrideAttrs (
            finalAttrs: oldAttrs: { patches = (prev.patches or [ ]) ++ patches; }
          );
        })
      ];
    };

  recursivelyImportDir =
    path:
    lib.concatMapAttrs (
      name: type:
      let
        attrName = lib.removePrefix "_" (lib.removeSuffix ".nix" name);
        fullPath = path + "/${name}";
        isDefault = name == "default.nix";
        isFile = type == "regular";
        isDirWithDefault = type == "directory" && lib.pathExists (fullPath + "/default.nix");
      in
      if isDefault then
        # The path itself is a default.nix file: don't import anything (it should be imported as a directory instead)
        { }
      else if isFile && !lib.hasSuffix ".nix" name then
        # The path is not a nix file
        { }
      else if isFile || isDirWithDefault then
        # Either the path is a file or it is a directory which contains a default.nix file: directly import it as a module
        {
          ${attrName} = import fullPath;
        }
      else
        # The path is a simple directory: recursively import its contents
        {
          ${attrName} = recursivelyImportDir fullPath;
        }

    ) (builtins.readDir path);

  # filterGetAttr =
  #   attrName: attrs:
  #   lib.concatMapAttrs (
  #     name: value:
  #     if value ? "${attrName}" then
  #       {
  #         ${name} = value.${attrName};
  #       }
  #     else
  #       { }
  #   ) attrs;

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = lib.strings.sanitizeDerivationName (builtins.baseNameOf path);
    };

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

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  # Create a shell alias that is shell-agnostic but can look up past commands
  mkShellHistoryAlias =
    {
      name,
      command,
    }:
    let
      historyCommands = {
        fish = ''$history[1]'';
        bash = ''$(fc -ln -1)'';
        zsh = ''''${history[@][1]}'';
      };

      mappedCommands = builtins.mapAttrs (
        _: lastCommand: command { inherit lastCommand; }
      ) historyCommands;
    in
    { config, ... }:
    {
      home-manager.users.${config.my.user.name} = {
        programs.bash.shellAliases.${name} = mappedCommands.bash;
        programs.fish.shellAliases.${name} = ''eval ${mappedCommands.fish}'';
        programs.zsh.shellAliases.${name} = ''eval ${mappedCommands.zsh}'';
      };
    };

  mkSyncedPath = { ... }: { };

  /*
    --------------------------------------------------------------------------------
    ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------------------------------------------------------------------------
  */

  mkSubmodule =
    opts:
    lib.mkOption {
      type = types.submodule {
        options = opts;
      };
      default = { };
    };

  mkAttrs =
    { options, ... }@attrArgs:
    lib.mkOption (
      {
        type = types.attrsOf (
          types.submodule (
            { config, ... }@submoduleArgs:
            {
              options =
                if lib.isAttrs options then
                  # the given options field is a simple attrset
                  options
                else
                  # the given options field is (probably) a function expecting the extra args
                  options (
                    submoduleArgs
                    // {
                      name = config._module.args.name;
                    }
                  );
            }
          )
        );
      }
      // (lib.removeAttrs attrArgs [ "options" ])
    );

  mkAttrs' =
    description: options:
    mkAttrs {
      inherit description options;
      default = { };
    };

}
