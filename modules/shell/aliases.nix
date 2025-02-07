{
  cfg,
  lib,
  constants,
  ...
}:

let
  inherit (lib) options types;
in
{
  options = {
    aliases = options.mkOption {
      type = types.attrsOf types.str;
      default = { };
    };

    aliasesWithHistory = options.mkOption {
      default = { };
      # No typechecking because I don't know how to typecheck for functions, but should be:
      # type = types.attrsOf function;
    };
  };

  config =
    # normal aliases
    {
      home-manager.users.${constants.user}.home.shellAliases = cfg.aliases;
    }
    # aliases with history
    // (lib.mapAttrs' (
      name: command:
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
      {
        home-manager.users.${constants.user} = {
          programs.bash.shellAliases.${name} = mappedCommands.bash;
          programs.fish.shellAliases.${name} = ''eval ${mappedCommands.fish}'';
          programs.zsh.shellAliases.${name} = ''eval ${mappedCommands.zsh}'';
        };
      }
    ) cfg.aliasesWithHistory);
}
