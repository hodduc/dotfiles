{ config, lib, pkgs, inputs, ... }:

let
  pkgs-mise = import inputs.nixpkgs-mise {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  programs.mise = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs-mise.mise;
  };

  # conf.d fragment (not config.toml) so mise can still write config.toml itself.
  home.file.".config/mise/conf.d/nix-defaults.toml".text = ''
    [settings]
    minimum_release_age = "7d"
    minimum_release_age_excludes = ["claude", "codex"]
  '';
}
