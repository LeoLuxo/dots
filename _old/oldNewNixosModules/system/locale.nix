{
  lib,
  config,
  ...
}:

let
  cfg = config.my.system.locale;
in
{
  options.my.system.locale = {
    enable = lib.mkEnableOption "locale";
  };

  config = lib.mkIf cfg.enable {
    # Set the time zone.
    time.timeZone = "Europe/Copenhagen";

    # Select internationalisation properties.
    # A good choice would also be english-(Ireland); see:
    # https://unix.stackexchange.com/questions/62316/why-is-there-no-euro-english-locale
    i18n.defaultLocale = "en_DK.UTF-8";
    i18n.extraLocaleSettings = {
      LC_TIME = "en_IE.UTF-8";
      # LC_ADDRESS = "en_IE.UTF-8";
      # LC_IDENTIFICATION = "en_IE.UTF-8";
      # LC_MEASUREMENT = "en_IE.UTF-8";
      # LC_MONETARY = "en_IE.UTF-8";
      # LC_NAME = "en_IE.UTF-8";
      # LC_NUMERIC = "en_IE.UTF-8";
      # LC_PAPER = "en_IE.UTF-8";
      # LC_TELEPHONE = "en_IE.UTF-8";
    };
  };
}
