{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.my.shell;
in
{
  options.my.shell = with lib2.options; {
    aliases = mkOpt "Shell command aliases" (types.attrsOf types.str) { };

    aliasesWithHistory = lib.mkOption {
      default = { };
      # No typechecking because I don't know how to typecheck for functions, but should be:
      # type = types.attrsOf function;
    };
  };

  config.my.hm = (
    lib.mkMerge (
      [
        # simple aliases
        {
          home.shellAliases = cfg.aliases;
        }
      ]
      ++
        # aliases with history
        lib.mapAttrsToList (name: commandFunc: {
          programs.bash.shellAliases.${name} = commandFunc ''$(fc -ln -1)'';
          programs.fish.shellAliases.${name} = ''eval ${commandFunc ''$history[1]''}'';
          programs.zsh.shellAliases.${name} = ''eval ${commandFunc ''''${history[@][1]}''}'';
        }) cfg.aliasesWithHistory
    )
  );
}
