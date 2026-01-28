{
  lib,
  pkgs,
  user,
  ...
}:
{
  # Vesktop keeps breaking and being buggy and pissing me off, and the default discord app works plenty fine atm :shrug:
  imports = [
    # ./vesktop
  ];

  environment.systemPackages = [
    pkgs.discord
  ];

  home-manager.users.${user} = {
    # Set discord as the default communication app
    home.sessionVariables = {
      APP_COMMUNICATION = lib.mkDefault "discord";
    };
  };
}
