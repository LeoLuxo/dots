{ ... }:
{
  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;

    silent = true;
    direnvrcExtra = ''
      export NIX_CONFIG="warn-dirty = false"
      echo -e "\033[1;96mDirenv loaded"

      __previous_dir="$PWD"
      export PROMPT_COMMAND='
        if [[ "$PWD" != "$__previous_dir" ]]; then
          echo -e "\033[1;91mDirenv unloaded"
          __previous_dir="$PWD"
        fi
      ':
    '';
  };
}
