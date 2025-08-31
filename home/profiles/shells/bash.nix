{ ... }:
{
  # Let home manager manage bash; needed to set sessionVariables
  programs.bash = {
    enable = true;
  };
}
