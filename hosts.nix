{ mkHost }:

{

  # Laptop (Surface Pro 7)
  "pancake" = mkHost {
    user = "lili";
    hostName = "pancake";
    system = "x86_64-linux";
    module = ./hosts/pancake;
  };

}
