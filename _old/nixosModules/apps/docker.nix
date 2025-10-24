{
  user,
  ...
}:

{
  virtualisation.docker.enable = true;

  my.user.extraGroups = [
    "docker"
  ];

}
