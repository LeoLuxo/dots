mkHost:

{
  # Personal desktop computer
  coffee = mkHost {
    hostname = "coffee";
    user = "lili";
    module = ./hosts/coffee;
  };

  # Surface Pro 7 laptop
  pancake = mkHost {
    hostname = "pancake";
    user = "lili";
    module = ./hosts/pancake;
  };
}
