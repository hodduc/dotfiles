{ config, lib, pkgs, inputs, ... }:

let
  # Unstable packages for latest versions
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  # codex pre-built binary (building from source takes too long)
  codex = pkgs.stdenv.mkDerivation rec {
    pname = "codex";
    version = "0.112.0";
    src = pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${version}/codex-aarch64-apple-darwin.tar.gz";
      hash = "sha256-Ge7j7cdEJJJjeERjSs2/RAEtmEzsMDmoRFlKpKrQRzg=";
    };
    sourceRoot = ".";
    unpackPhase = ''
      tar xzf $src
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp codex-aarch64-apple-darwin $out/bin/codex
      chmod +x $out/bin/codex
    '';
  };

  # docker -> nerdctl wrapper (aliases don't work in scripts/Makefiles)
  docker-wrapper = pkgs.writeShellScriptBin "docker" ''
    exec nerdctl "$@"
  '';

  # aykamko/tag from TheLonelyGhost/tag fork
  tag = pkgs.buildGoModule {
    pname = "tag";
    version = "1.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "hodduc";
      repo = "tag";
      rev = "5c6a6e255b0b72a6531f4624a12e59e9cf3ea5e9";
      sha256 = "sha256-/mqDcG9hAbBjuGtyq0SBxRudCO4E0/wdzRmBUPXxrmM=";
    };

    vendorHash = "sha256-/Gsqc8rEptMBItqeb/N/gE4V3iUGZa8k1GqUR1+togY=";

    meta = with lib; {
      description = "Instantly jump to your ag or ripgrep matches";
      homepage = "https://github.com/hodduc/tag";
      license = licenses.mit;
      platforms = platforms.unix;
    };
  };
in
{
  # Install packages from Nixpkgs. See https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Development tools
    kubectl
    kubectl-node-shell
    kubectx
    kubernetes-helm
    k9s
    pkgs-unstable.claude-code  # Use unstable for latest version
    codex
    colima
    docker-wrapper
    corepack
    nodejs
    python3
    uv
    jujutsu

    # CLI utilities
    bat
    ripgrep
    gh
    awscli2
    saml2aws
    tag
    step-cli

    # Applications
    wezterm
    ghostty-bin
  ];
}
