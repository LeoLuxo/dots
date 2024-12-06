{
  user,
  musnix,
  ...
}:
{
  imports = [ musnix.nixosModules.musnix ];

  musnix.enable = true;
  users.users.${user}.extraGroups = [ "audio" ];
}
