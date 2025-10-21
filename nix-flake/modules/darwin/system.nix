{ config, pkgs, lib, ... }:

{
  imports = [
    ./macos-defaults.nix
  ];

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # Enable zsh system-wide
  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    nanum
    nanum-gothic-coding
    nerd-fonts.jetbrains-mono
  ];
}