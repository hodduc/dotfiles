{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  
  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        export KUBE_EDITOR=vim
        export K9S_EDITOR=vim
        export EDITOR=vim
        export DIRENV_LOG_FORMAT=$'\033[2mdirenv: %s\033[0m'
        #source ~/.hooks.zsh
        #source ~/.zshrc
      '')
      ''
        export PATH=$PATH:~/.cargo/bin
        export AWS_PROFILE=saml

        bindkey "\e[1;3D" backward-word     # ⌥←
        bindkey "\e[1;3C" forward-word      # ⌥→

        # tag integration for ripgrep
        if (( $+commands[tag] )); then
          export TAG_SEARCH_PROG=rg
          tag() { command tag "$@"; source ''${TAG_ALIAS_FILE:-/tmp/tag_aliases} 2>/dev/null }
          alias rg=tag
        fi
      ''
    ];
    shellAliases = {
      awslogin = "saml2aws login --force --session-duration=43200 --disable-keychain";
      vaultlogin = "vault login -method=oidc";
      # Terraform
      tf = "terraform";
      kc = "kubectl";

      # Modern CLI tools
      cat = "bat --paging never --theme DarkNeon --style plain";
      ack = "rg";
    };
    plugins = [
#       {
#         name = "powerlevel10k";
#         src = pkgs.zsh-powerlevel10k;
#         file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
#       }
    ];
    autosuggestion.enable = true;
    history.path = "${config.home.homeDirectory}/.zsh_history";
  };
  
  # home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
  # home.file.".hooks.zsh".text = (builtins.readFile ./hooks.zsh);
}
