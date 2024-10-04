{ mkHost, ... }:

{

  # Laptop (Surface Pro 7)
  "pancake" = mkHost {
    user = "lili";
    system = "x86_64-linux";
    hostModule = ./hosts/pancake;
  };

}
