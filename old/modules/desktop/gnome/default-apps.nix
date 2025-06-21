{
  pkgs,
  config,
  ...
}:
{
  # Disable or enable default gnome apps here
  #! CAREFUL, LIST IS INVERTED -> commented out = KEEP
  environment.gnome.excludePackages = with pkgs; [
    # baobab # disk usage analyzer
    cheese # photo booth
    epiphany # web browser
    gedit # text editor
    simple-scan # document scanner
    # totem # video player
    yelp # help viewer
    # evince # document viewer
    # file-roller # archive manager
    geary # email client
    # seahorse # password manager
    # gnome-connections # remote computer connection thingie
    eog # image viewer (older I think?)
    # loupe # newer image viewer
    gnome-tour
    gnome-user-docs
    # gnome-calculator
    # gnome-calendar
    # gnome-characters
    # gnome-clocks
    # gnome-contacts
    # gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    # gnome-photos
    # gnome-screenshot
    # gnome-system-monitor
    gnome-weather
    # gnome-disk-utility
  ];

  # Remove xterm from the gnome apps list
  services.xserver.excludePackages = with pkgs; [
    xterm
  ];
}
