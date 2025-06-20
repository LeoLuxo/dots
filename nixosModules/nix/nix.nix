{ lib, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the new nix cli tool and flakes
  nix.settings.experimental-features = [
    (lib.traceVal "nix-command")
    "flakes"
  ];
}
