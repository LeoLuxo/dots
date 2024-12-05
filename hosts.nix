mkHost: {

  # Desktop
  "coffee" = mkHost {
    user = "lili";
    hostName = "coffee";
    system = "x86_64-linux";
    modules = [
      ./hosts/coffee
      ./hosts/common.nix
      ./hosts/secrets.nix
    ];
  };

  # Laptop (Surface Pro 7)
  "pancake" = mkHost {
    user = "lili";
    hostName = "pancake";
    system = "x86_64-linux";
    modules = [
      ./hosts/pancake
      ./hosts/common.nix
      ./hosts/secrets.nix
    ];
  };

}
