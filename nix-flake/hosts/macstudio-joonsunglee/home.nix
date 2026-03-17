{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../home/default.nix
    (inputs.private + "/nix/devsisters.nix")
  ];
}
