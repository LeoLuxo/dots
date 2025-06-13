{
  constants,
  ...
}:

let
  inherit (constants) user;
in

{
  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = user;
  };
}
