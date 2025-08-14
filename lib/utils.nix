{ lib, ... }:

{
  sanitizePath =
    path:
    builtins.path {
      inherit path;
      name = lib.strings.sanitizeDerivationName (builtins.baseNameOf path);
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

  # Create a shell alias that is shell-agnostic but can look up past commands
  mkShellHistoryAlias =
    {
      name,
      command,
    }:
    { };
  # let
  #   historyCommands = {
  #     fish = ''$history[1]'';
  #     bash = ''$(fc -ln -1)'';
  #     zsh = ''''${history[@][1]}'';
  #   };

  #   mappedCommands = builtins.mapAttrs (
  #     _: lastCommand: command { inherit lastCommand; }
  #   ) historyCommands;
  # in
  # { constants, config, ... }:
  # {
  #   home-manager.users.${config.my.user.name} = {
  #     programs.bash.shellAliases.${name} = mappedCommands.bash;
  #     programs.fish.shellAliases.${name} = ''eval ${mappedCommands.fish}'';
  #     programs.zsh.shellAliases.${name} = ''eval ${mappedCommands.zsh}'';
  #   };
  # };
}
