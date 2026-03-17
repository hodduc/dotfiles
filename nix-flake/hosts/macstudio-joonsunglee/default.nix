{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/darwin/system.nix
    ../../modules/common/nix.nix
    "${inputs.private}/nix/github-tokens.nix"
  ];

  # System-specific configuration for this host
  system = {
    # Set Git commit hash for darwin-version
    configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

    # Used for backwards compatibility
    stateVersion = 6;
  };

  # Primary user for this system
  system.primaryUser = "hodduc";

  # The platform the configuration will be used on
  nixpkgs.hostPlatform = "aarch64-darwin";

  # User configuration
  users.users.hodduc = {
    name = "hodduc";
    home = "/Users/hodduc";
    shell = pkgs.zsh;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    vim
  ];
}
