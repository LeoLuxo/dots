mkHost: {

  # Desktop
  "coffee" =
    mkHost
      [
        ./hosts/coffee

        ./hosts/commonSoftware.nix
        ./hosts/nixBase.nix
        ./hosts/secrets.nix
      ]
      {
        user = "lili";
        hostName = "coffee";
        system = "x86_64-linux";

        resticRepoHot = "/stuff/Restic/repo";
        resticRepoCold = "/backup/Restic/repo";
      };

  # Laptop (Surface Pro 7)
  "pancake" =
    mkHost
      [
        ./hosts/pancake

        ./hosts/commonSoftware.nix
        ./hosts/nixBase.nix
        ./hosts/secrets.nix
      ]
      {
        user = "lili";
        hostName = "pancake";
        system = "x86_64-linux";

        resticRepoHot = "/stuff/Restic/repo";
      };
}
