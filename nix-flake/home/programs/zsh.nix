{ config, lib, pkgs, ... }:

{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    initContent = lib.mkMerge [
      (lib.mkBefore ''
        export KUBE_EDITOR=vim
        export K9S_EDITOR=vim
        export EDITOR=vim
        source ~/.p10k.zsh
        source ~/.hooks.zsh
        source ~/.zshrc
      '')
      ''
        [[ ! -f $(dirname $(dirname $(readlink -f $(which asdf))))/asdf.sh ]] || source $(dirname $(dirname $(readlink -f $(which asdf))))/asdf.sh
        [[ ! -f $(dirname $(dirname $(readlink -f $(which asdf))))/share/asdf-vm/asdf.sh ]] || source $(dirname $(dirname $(readlink -f $(which asdf))))/share/asdf-vm/asdf.sh
        export PATH=$PATH:~/.cargo/bin
        export AWS_PROFILE=saml
        export VAULT_ADDR=https://vault.devsisters.cloud

        bindkey "\e[1;3D" backward-word     # ⌥←
        bindkey "\e[1;3C" forward-word      # ⌥→
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
  };
  
  # home.file.".p10k.zsh".text = (builtins.readFile ./p10k.zsh);
  # home.file.".hooks.zsh".text = (builtins.readFile ./hooks.zsh);
}
