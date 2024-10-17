{ user, ... }:
{
  imports = [
    ./fix-dark-mode.nix
  ];

  home-manager.users.${user} = {
    imports = [
      ./hm-module.nix
    ];
  };
}
