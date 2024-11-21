{
  ...
}:
{

  programs = {

    # Setup firefox.
    firefox = {
      enable = true;
      policies =
        let
          lock-false = {
            Value = false;
            Status = "locked";
          };
          lock-true = {
            Value = true;
            Status = "locked";
          };
        in
        {
          Preferences = {
            "middlemouse.paste" = lock-false;
          };
        };
    };

  };
}
