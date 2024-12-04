{
  user,
  ...
}:
{
  home-manager.users.${user} = {
    # Let home manager manage bash; needed to set sessionVariables
    programs.bash.enable = true;
  };
}
