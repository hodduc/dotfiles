{ config, lib, pkgs, ... }:

{
  # Enable neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Symlink existing nvim config
  home.file.".config/nvim" = {
    source = ../../../nvim;
    recursive = true;
  };
}
