{ config, lib, pkgs, inputs, ... }:

let
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
    kubectx
    kubernetes-helm
    claude-code
    colima
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
  ];
}
