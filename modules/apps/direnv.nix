{ constants, ... }:
{
  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;

    silent = true;
    direnvrcExtra = ''
      # Suppress the "git tree is dirty" warnings
      export NIX_CONFIG="warn-dirty = false"

      # Set a higher timeout to prevent the warning "direnv is taking too long"
      export DIRENV_WARN_TIMEOUT=100y

      echo -e "\033[1;96mDirenv loaded"
    '';
  };

  home-manager.users.${constants.user} = {

    # Add aliases
    home.shellAliases = {
      da = "direnv allow";
      ok = "da";
    };
  };
}