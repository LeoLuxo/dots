mkHost: {

  # Desktop
  "coffee" =
    mkHost
      [
        ./hosts/coffee
        ./hosts/common.nix
        ./hosts/secrets.nix
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
        ./hosts/common.nix
        ./hosts/secrets.nix
      ]
      {
        user = "lili";
        hostName = "pancake";
        system = "x86_64-linux";
      };

}
