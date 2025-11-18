{ config, lib, pkgs, ... }:

{
  # Install packages from Nixpkgs. See https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Development tools
    kubectl
    kubectx
    kubernetes-helm
    claude-code
    colima
    python3

    # CLI utilities
    bat
    ripgrep
    gh
    awscli2
    saml2aws

    # Applications
    wezterm
  ];
}
