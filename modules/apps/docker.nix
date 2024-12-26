{
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  virtualisation.docker.enable = true;

  users.users.${user}.extraGroups = [
    "docker"
  ];

}
