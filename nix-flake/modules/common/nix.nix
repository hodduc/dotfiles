{ config, pkgs, lib, ... }:

{
  # Nix settings shared across all systems
  
  nix = {
    settings = {
      # Enable flakes
      experimental-features = [ "nix-command" "flakes" ];
      
      # Trusted users
      trusted-users = [ "root" "@wheel" ];
      
      # Binary caches
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    
    # Optimize storage
    optimise.automatic = true;
    
    # Garbage collection
    gc = {
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 30d";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Allow specific insecure packages that are still required
  nixpkgs.config.permittedInsecurePackages = [
    "lima-full-1.2.2"
  ];
}
