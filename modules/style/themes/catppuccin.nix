{
  user,
  catppuccin,
  ...
}:

{
  imports = [
    catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    # Enable the theme for all compatible apps
    enable = true;

    # Choose flavor
    flavor = "frappe";
    accent = "blue";
  };

  home-manager.users.${user} = {
    imports = [
      catppuccin.homeManagerModules.catppuccin
    ];

    # Enable catppuccin for gtk
    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "frappe";
        accent = "blue";
        size = "standard";
        tweaks = [ "normal" ];
      };
    };
  };

  boot.plymouth.catppuccin.enable = false;
}