{
  ...
}:

{
  virtualisation.docker.enable = true;

  ext.system.user.extraGroups = [
    "docker"
  ];

}
