{ config, lib, pkgs, inputs, ... }:

let
  # Unstable packages for latest versions
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };

  # codex version override
  # Using importCargoLock instead of fetchCargoVendor due to -Z bindeps parse failure in rules_rust git dep.
  # TODO: Switch back to fetchCargoVendor after https://github.com/NixOS/nixpkgs/pull/486323
  codex = pkgs-unstable.codex.overrideAttrs (old: rec {
    version = "0.112.0";
    src = pkgs.fetchFromGitHub {
      owner = "openai";
      repo = "codex";
      tag = "rust-v${version}";
      hash = "sha256-tOrqGXh4k5GzcPhCUaiYoUVt4liYfgRd2ejkrdQpqWs=";
    };
    sourceRoot = "${src.name}/codex-rs";
    cargoDeps = pkgs-unstable.rustPlatform.importCargoLock {
      lockFile = src + "/codex-rs/Cargo.lock";
      outputHashes = {
        "crossterm-0.28.1" = "sha256-6qCtfSMuXACKFb9ATID39XyFDIEMFDmbx6SSmNe+728=";
        "nucleo-0.5.0" = "sha256-Hm4SxtTSBrcWpXrtSqeO0TACbUxq3gizg1zD/6Yw/sI=";
        "ratatui-0.29.0" = "sha256-HBvT5c8GsiCxMffNjJGLmHnvG77A6cqEL+1ARurBXho=";
        "runfiles-0.1.0" = "sha256-uJpVLcQh8wWZA3GPv9D8Nt43EOirajfDJ7eq/FB+tek=";
        "tokio-tungstenite-0.28.0" = "sha256-hJAkvWxDjB9A9GqansahWhTmj/ekcelslLUTtwqI7lw=";
        "tungstenite-0.27.0" = "sha256-AN5wql2X2yJnQ7lnDxpljNw0Jua40GtmT+w3wjER010=";
      };
    };
  });

  # aykamko/tag from TheLonelyGhost/tag fork
  tag = pkgs.buildGoModule {
    pname = "tag";
    version = "1.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "TheLonelyGhost";
      repo = "tag";
      rev = "5032627ae5e26f19cf31444f1f7aa1f7d3cedf1d";
      sha256 = "sha256-WQB3q+cOUXWIekyyjB7C4AvIpQirk4ih8BAhcGVX2u8=";
    };

    vendorHash = "sha256-rEb6Q6b3+XKY+8Pn6xkNMLqUeKaqXCdFwh3Sd6NePs4=";

    meta = with lib; {
      description = "Instantly jump to your ag or ripgrep matches";
      homepage = "https://github.com/TheLonelyGhost/tag";
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
    corepack
    python3

    # CLI utilities
    bat
    ripgrep
    gh
    awscli2
    saml2aws
    tag

    # Applications
    wezterm
    ghostty-bin
  ];
}
