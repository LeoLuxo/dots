{ mkHost, newModules }:
{

  # Desktop
  "coffee" =
    mkHost
      [
        ./../nixosConfigurations/coffee
      ]
      {
        # user = "lili";
        hostname = "coffee";
        system = "x86_64-linux";
      };

  # Laptop (Surface Pro 7)
  "pancake" =
    mkHost
      [
        newModules
        ./hosts/pancake
      ]
      {
        # user = "lili";
        hostname = "pancake";
        system = "x86_64-linux";
      };
}
