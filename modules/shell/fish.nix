{
  pkgs,
  lib,
  constants,
  ...
}:

let
  inherit (constants) user;
in
{
  imports = [ ./module.nix ];

  shell.default = lib.mkDefault "fish";

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  home-manager.users.${user} = {
    programs.fish = {
      enable = true;

      shellAliases = {
        last-command = "history --search -n 1";
      };

      shellInit = ''
        # Bind CTRL-backspace 
        bind -k backspace backward-kill-path-component

        # Bind CTRL-W
        bind \cw backward-kill-bigword

        # Bind CTRL-Delete
        bind \e\[3\;5~ kill-bigword

        # Rebind left to accept only a single word instead of the entire autosuggestion
        bind \e\[C forward-word
      '';
    };
  };
}
