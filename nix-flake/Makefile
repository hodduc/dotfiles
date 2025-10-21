.PHONY: update darwin home apply gc refresh-darwin refresh-home refresh

# Update flake inputs to latest versions
update:
	nix flake update

# Build and apply Darwin system configuration (requires sudo)
darwin:
	darwin-rebuild switch --flake .#macbook-joonsunglee

# Build and apply Home Manager configuration (no sudo needed!)
home:
	home-manager switch --flake .#hodduc

# Apply both Darwin and Home Manager configurations
apply: darwin home

# Clean up old generations and garbage collect
gc:
	nix-collect-garbage -d

# Update and rebuild Darwin only
refresh-darwin: update darwin gc

# Update and rebuild Home Manager only (no sudo!)
refresh-home: update home

# Update and rebuild everything
refresh: update apply gc
