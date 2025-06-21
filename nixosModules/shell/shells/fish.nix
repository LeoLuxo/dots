{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.my.shell.fish;
in
{
  options.my.shell.fish = {
    enable = lib.mkEnableOption "fish";
  };

  config = lib.mkIf cfg.enable {
    my = {
      shell.defaultShell = lib.mkDefault "fish";

      hm.programs.fish = {
        enable = true;

        # Use fish_key_reader to get keycodes
        # https://fishshell.com/docs/current/cmds/bind.html
        shellInit = ''
          # Bind backspace correctly just to make sure
          bind backspace backward-delete-char

          # Rebind CTRL-backspace
          bind ctrl-h backward-kill-path-component

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

    programs.fish.enable = true;
    environment.shells = [ pkgs.fish ];
  };
}
