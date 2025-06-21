{
  constants,
  config,
  ...
}:

{
  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = config.my.system.user.name;
  };
}
