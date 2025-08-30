{
  inputs,
  pkgs,
  lib2,
  ...
}:

inputs.home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  # Additional args passed to the modules
  extraSpecialArgs = {
    inherit inputs lib2;
    inherit (inputs.self) homeModules homeProfiles;

    hostname = "coffee";
    user = "lili";
  }; # This raise an error

  modules = [
    inputs.self.homeProfiles.base

    {

    }
  ];
}
