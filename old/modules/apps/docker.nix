{
  ...
}:

{
  virtualisation.docker.enable = true;

  my.system.user.extraGroups = [
    "docker"
  ];

}
