{ config, lib, pkgs, ... }:

{
  # Install packages from Nixpkgs. See https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Development tools
    kubectl
    claude-code
    colima

    # CLI utilities
    bat
    ripgrep
    gh
    saml2aws

    # Applications
    wezterm
    slack
  ];
}
