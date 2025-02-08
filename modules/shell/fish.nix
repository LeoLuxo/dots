{
  config,
  lib,

  constants,
  pkgs,
  ...
}:

let
  inherit (lib) modules;
  inherit (extraLib) mkEnable;
in
{
  options = {
    enable = mkEnable;
  };

  config = modules.mkIf cfg.enable {
    shell.defaultShell = lib.mkDefault "fish";

    programs.fish.enable = true;
    environment.shells = [ pkgs.fish ];

    home-manager.users.${constants.user} = {
      programs.fish = {
        enable = true;

        # Use fish_key_reader to get keycodes
        # https://fishshell.com/docs/current/cmds/bind.html
        shellInit = ''
          # Rebind CTRL-backspace
          bind -k backspace backward-kill-path-component

          # Bind CTRL-W
          bind \cw backward-kill-bigword

          # Bind CTRL-Delete
          bind \e\[3\;5~ kill-bigword

          # Bind CTRL-\|
          bind \x1c beginning-of-line

          # Rebind right to accept only a single char instead of the entire autosuggestion
          bind \e\[C forward-single-char

          # Bind CTRL-Space to open autocomplete search
          bind -k nul complete-and-search

          # Rebind tab to accept suggestion
          bind \t accept-autosuggestion
        '';
      };
    };
  };
}
