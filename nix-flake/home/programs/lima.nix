{ pkgs, inputs, ... }:

let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = [ pkgs-unstable.lima ];

  # Templates live under ~/.lima/_templates and are referenced as:
  #   limactl start --name=<instance> template:<name>
  # Instance state (disk images, logs, etc.) stays under ~/.lima/<instance>/
  # and is managed by lima itself, not by nix.
  home.file = {
    # Colima-like default: containerd + nerdctl on Ubuntu, vz backend (arm64 only).
    ".lima/_templates/docker.yaml".text = ''
      vmType: "vz"
      vmOpts:
        vz:
          rosetta:
            enabled: false
            binfmt: false
      images:
      - location: "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-arm64.img"
        arch: "aarch64"
      - location: "https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img"
        arch: "x86_64"
      cpus: 4
      memory: "8GiB"
      disk: "60GiB"
      mountType: "virtiofs"
      mounts:
      - location: "~"
      - location: "/tmp/lima"
        writable: true
      containerd:
        system: false
        user: true
    '';
  };
}
