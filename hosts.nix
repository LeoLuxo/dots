mkHost: {

  # Desktop
  "coffee" =
    mkHost
      [
        ./hosts/coffee
        ./hosts/base.nix
        ./hosts/secrets.nix
        ./hosts/keybinds.nix
      ]
      {
        user = "lili";
        hostName = "coffee";
        system = "x86_64-linux";
      };

  # Laptop (Surface Pro 7)
  "pancake" =
    mkHost
      [
        ./hosts/pancake
        ./hosts/base.nix
        ./hosts/secrets.nix
        ./hosts/keybinds.nix
      ]
      {
        user = "lili";
        hostName = "pancake";
        system = "x86_64-linux";
      };
}
