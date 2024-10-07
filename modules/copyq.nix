{ user, ... }:

{
  home-manager.users.${user} = {

    services.copyq.enable = true;
  };

}
