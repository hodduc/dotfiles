{ config, pkgs, lib, inputs, ... }:

{
  # Home Manager configuration
  
  home = {
    username = "hodduc";
    homeDirectory = "/Users/hodduc";

    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.11";
    
    # Disable version mismatch warnings since we're using unstable nixpkgs
    enableNixpkgsReleaseCheck = false;
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/hodduc/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    LC_ALL = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Import all home modules
  imports = [
    ./packages.nix
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/wezterm.nix
    ./programs/neovim.nix
  ];
}
