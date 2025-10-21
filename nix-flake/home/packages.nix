{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development tools
    kubectl
    claude-code
    colima

    # Terminal
    wezterm

    # CLI utilities
    bat
    eza
    ripgrep

    # Applications
    slack

    # Add more packages here as needed
  ];
}
