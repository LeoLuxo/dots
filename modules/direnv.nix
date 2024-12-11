{ ... }:
{
  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;

    silent = true;
    direnvrcExtra = ''
      export NIX_CONFIG="warn-dirty = false"
      echo -e "\033[1;96mDirenv reloaded"
    '';
  };
}
