{ ... }:
{
  programs.direnv = {
    enable = true;

    nix-direnv.enable = true;

    silent = true;
    stdlib = ''
      # Set a higher timeout to prevent the warning "direnv is taking too long"
      # export DIRENV_WARN_TIMEOUT=100h

      echo -e "\033[1;96mDirenv loaded"
    '';
  };

  home.sessionVariables = {
    # Set a higher timeout to prevent the warning "direnv is taking too long"
    DIRENV_WARN_TIMEOUT = "100h";
  };

  home.shellAliases = {
    da = "direnv allow";
    dr = "direnv reload";

    ok = "da";
  };
}
