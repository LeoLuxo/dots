{
  lib,
  config,
  inputs,
  ...
}:

let
  lib2 = inputs.self.lib;
  inherit (lib) types;

  cfg = config.ext.shell.aliases;
in
{
  options.ext.shell = {
    aliases = with lib2.options; mkOpt "Shell command aliases" types.attrsOf types.str { };

    aliasesWithHistory = lib.options.mkOption {
      default = { };
      # No typechecking because I don't know how to typecheck for functions, but should be:
      # type = types.attrsOf function;
    };
  };

  config = # normal aliases
    {
      ext.hm.home.shellAliases = cfg.aliases;
    }
    //
    # aliases with history
    (lib.mkMerge (
      lib.mapAttrsToList (
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
          ext.hm = {
            programs.bash.shellAliases.${name} = mappedCommands.bash;
            programs.fish.shellAliases.${name} = ''eval ${mappedCommands.fish}'';
            programs.zsh.shellAliases.${name} = ''eval ${mappedCommands.zsh}'';
          };
        }
      ) cfg.aliasesWithHistory
    ));

  # // (lib.mapAttrs (
  #   name: command:
  #   let
  #     historyCommands = {
  #       fish = ''$history[1]'';
  #       bash = ''$(fc -ln -1)'';
  #       zsh = ''''${history[@][1]}'';
  #     };

  #     mappedCommands = builtins.mapAttrs (
  #       _: lastCommand: command { inherit lastCommand; }
  #     ) historyCommands;
  #   in
  #   {
  #     # ext.hm = {
  #     #   programs.bash.shellAliases.${name} = mappedCommands.bash;
  #     #   programs.fish.shellAliases.${name} = ''eval ${mappedCommands.fish}'';
  #     #   programs.zsh.shellAliases.${name} = ''eval ${mappedCommands.zsh}'';
  #     # };
  #   }
  # ) (lib.traceVal cfg.aliasesWithHistory));
}
