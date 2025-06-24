{ mkHost, newModules }:
{

  # Desktop
  "coffee" = mkHost [ newModules ./hosts/coffee ] {
    # user = "lili";
    hostname = "coffee";
    system = "x86_64-linux";

    resticRepoHot = "/stuff/Restic/repo";
    resticRepoCold = "/backup/Restic/repo";
  };

  # Laptop (Surface Pro 7)
  "pancake" = mkHost [ newModules ./hosts/pancake ] {
    # user = "lili";
    hostname = "pancake";
    system = "x86_64-linux";

    resticRepoHot = "/stuff/Restic/repo";
  };
}
