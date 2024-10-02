{
  description = "My Nix configuration :)";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Contains certain nixos hardware settings, specifically for surface laptops
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # Manages dotfiles in nix
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Encryption thingie, used for secrets in nix
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      # optionally choose not to download darwin deps (saves some resources on Linux)
      inputs.darwin.follows = "";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      rootPath = "${./.}";
      getModule = path: rootPath + "/modules/${path}";
      # getScript = path: (./scripts + "/${path}");
      mkConfig = (
        system: module:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            module
          ];
          specialArgs = inputs // {
            inherit system;
            # inherit getScript;
            inherit getModule;
          };
        }
      );
    in
    {
      nixosConfigurations = {
        # Laptop (Surface Pro 7)
        "pancake" = mkConfig "x86_64-linux" ./hosts/pancake;
      };
    };
}
