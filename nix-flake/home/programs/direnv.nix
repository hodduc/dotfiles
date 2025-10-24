{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;

    nix-direnv.enable = true;
    mise.enable = true;

    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
}
