{ config, lib, pkgs, ... }:

{
  # Enable neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    # home-manager 26.05 flipped these defaults to false; keep prior behavior.
    withPython3 = true;
    withRuby = true;
    # home-manager 26.05 writes generated lua (provider setup) to
    # ~/.config/nvim/init.lua by default, which conflicts with our init.vim
    # (nvim refuses to load init.vim when init.lua exists; E5422).
    # Sideload it through the wrapper (--cmd) instead, like 25.11 did.
    sideloadInitLua = true;
  };

  # Symlink existing nvim config
  home.file.".config/nvim" = {
    source = ../../../nvim;
    recursive = true;
  };
}
