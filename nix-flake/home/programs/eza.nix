{ config, lib, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;

    git = false;
    icons = "never";
    extraOptions = [
      "--group-directories-first"
      "--classify=always"
    ];
  };
}
