{ config, lib, pkgs, inputs, ... }:

let
  # Use unstable VSCode for latest version
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  vscodeUserDir = "Library/Application Support/Code/User";
  vscodeConfigDir = "${config.home.homeDirectory}/repos/dotfiles/vscode";
in
{
  programs.vscode = {
    enable = true;
    package = pkgs-unstable.vscode;
  };

  # Link settings/keybindings to the real files in this repo (not the nix
  # store) so they stay editable from the VSCode GUI while remaining
  # version-controlled. Do not set programs.vscode.profiles.*.userSettings,
  # keybindings, or enableUpdateCheck here — those regenerate read-only
  # store-backed files that conflict with these symlinks.
  home.file."${vscodeUserDir}/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${vscodeConfigDir}/settings.json";
  home.file."${vscodeUserDir}/keybindings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${vscodeConfigDir}/keybindings.json";
}
