{ config, pkgs, lib, ... }:

{
  programs.git = {
    enable = true;
    includes = [
      { path = "${config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles/gitconfig"}"; }
    ];
  };
  
  # Link the gitignore file to the expected location
  home.file.".gitignore_global".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/repos/dotfiles/gitignore";

  programs.zsh.shellAliases = {
    git = "LC_ALL=en_US.UTF-8 git";
    gf = "git fetch -p";
    gco = "git checkout";
    gpl = "git pull";
    gph = "git push";
    gsh = "git stash";
    gsp = "git stash pop";
    glg = "git log";
    grb = "git rebase";
    grbi = "git rebase -i";
  };

  home.packages = with pkgs; [
    git-lfs
    rs-git-fsmonitor
    delta
  ];
}

