{ user, ... }:
{
  imports = [ ./agenix.nix ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
  };
}
