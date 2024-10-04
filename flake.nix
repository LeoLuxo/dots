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

    with nixpkgs.lib;
    with import ./libs.nix inputs;

    {
      # Define nixos configs
      nixosConfigurations = import ./hosts.nix extraInputs;
    };
}
