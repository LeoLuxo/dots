mkHost:

{
  # Personal desktop computer
  coffee = mkHost {
    hostname = "coffee";
    user = "lili";
    module = ./coffee/configuration.nix;
  };

  # Surface Pro 7 laptop
  pancake = mkHost {
    hostname = "pancake";
    user = "lili";
    module = ./pancake/configuration.nix;
  };
}
