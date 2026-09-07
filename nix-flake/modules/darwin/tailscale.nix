{ config, pkgs, lib, ... }:

{
  # Tailscale client daemon (open-source tailscaled via launchd).
  # Authenticate after apply with: sudo tailscale up
  services.tailscale.enable = true;
}
