{
  user,
  ...
}:
{
  home-manager.users.${user} = {
    programs.zsh.enable = true;
  };
}
