{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Development tools
    kubectl
    claude-code
    
    # Terminal
    wezterm
    
    # Add more packages here as needed
  ];
}
