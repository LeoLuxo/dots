{ lib, ... }:
{
  imports = [
    # Discord fork that fixes streaming issues on linux
    ./vesktop
  ];

  # Set discord as the default communication app
  home.sessionVariables = {
    APP_COMMUNICATION = lib.mkDefault "discord";
  };
}
