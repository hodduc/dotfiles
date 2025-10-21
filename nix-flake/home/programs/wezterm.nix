{ config, lib, pkgs, ... }:

{
  # WezTerm configuration
  # Symlinks the wezterm.lua config from the parent dotfiles directory
  home.file.".wezterm.lua".source = ../../../wezterm.lua;
}
