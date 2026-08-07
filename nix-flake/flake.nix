{
  inputs = {
    # self.submodules = true;  # Alternative: auto-fetch all submodules

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # https://hydra.nixos.org/build/339923753 에서 darwin-arm64 빌드가 깨져 캐시를 타지 않고 있어서
    # 임시로 fallback 한다
    nixpkgs-mise.url = "github:NixOS/nixpkgs/b7a3820e9ee222085c654bb4a0aee7ecccdd26ea";

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    private.url = "git+file:./private";
    private.flake = false;
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nixpkgs-unstable, home-manager, ... }:
  let
    username = "hodduc";
  in
  {
    # Darwin system configuration
    # Build using: darwin-rebuild switch --flake .#macbook-joonsunglee
    darwinConfigurations = {
      "macbook-joonsunglee" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/macbook-joonsunglee ];
      };
      "macstudio-joonsunglee" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/macstudio-joonsunglee ];
      };
    };

    # Standalone Home Manager configuration
    # Build using: home-manager switch --flake .#hodduc@macbook-joonsunglee
    homeConfigurations = {
      "${username}@macbook-joonsunglee" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
            ];
          };
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./hosts/macbook-joonsunglee/home.nix ];
      };
      "${username}@macstudio-joonsunglee" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [
            ];
          };
        };
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./hosts/macstudio-joonsunglee/home.nix ];
      };
    };
  };
}
