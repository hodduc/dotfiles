{ config, pkgs, ... }:

let
  plugins = {
    fluent-korean = {
      source = pkgs.fetchFromGitHub {
        owner = "snflkd";
        repo = "fluent-korean";
        rev = "ce8683f0eba8cddb91de4dcd151425ff73e60498";
        hash = "sha256-YJl3hPUOBDGwY7WIJx7AKxiC6Avs2pD+9RqlKKsMBzY=";
      };
      installName = "fluent-korean@fluent-korean";
    };
  };

  pluginSeed = pkgs.runCommand "claude-code-plugin-seed" {
    nativeBuildInputs = [ pkgs.claude-code ];
  } ''
    mkdir -p "$out" "$TMPDIR/claude-config"
    export CLAUDE_CONFIG_DIR="$TMPDIR/claude-config"
    export CLAUDE_CODE_PLUGIN_CACHE_DIR="$out"
    export DISABLE_AUTOUPDATER=1

    claude plugin marketplace add ${plugins.fluent-korean.source}
    claude plugin install ${plugins.fluent-korean.installName}

    cp -R ${plugins.fluent-korean.source} "$out/marketplaces/fluent-korean"
  '';
in
{
  # Enable fluent-korean and select its output style manually in both
  # claude-work and claude-personal after applying the Home Manager config.
  home.sessionVariables.CLAUDE_CODE_PLUGIN_SEED_DIR = "${pluginSeed}";

  programs.zsh.shellAliases = {
    claude = "echo 'Use claude-work or claude-personal instead.' && return 1";
    claude-work = "CLAUDE_CONFIG_DIR=${config.home.homeDirectory}/.claude-work DISABLE_AUTOUPDATER=1 command claude";
    claude-personal = "CLAUDE_CONFIG_DIR=${config.home.homeDirectory}/.claude-personal DISABLE_AUTOUPDATER=1 command claude";
  };
}
