{ ... }:
{
  # zoxide, the smarter `cd` command
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish.functions = {
    cd = ''
      # If the 'z' command exists, use it, otherwise fall back to builtin cd
      # (For some reason my vscode builtin terminal doesn't have accesss to 'z')
      if type -q z
          z $argv
      else
          builtin cd $argv
      end
    '';
  };
}
