mkHost: {

  # Desktop
  "coffee" = mkHost {
    user = "lili";
    hostName = "coffee";
    system = "x86_64-linux";
    modules = [
      #./hosts/common.nix
      ./hosts/coffee
    ];
  };

  # Laptop (Surface Pro 7)
  "pancake" = mkHost {
    user = "lili";
    hostName = "pancake";
    system = "x86_64-linux";
    modules = [
      ./hosts/common.nix
      ./hosts/pancake
    ];
  };

}
