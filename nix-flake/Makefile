.PHONY: update darwin home apply gc refresh-darwin refresh-home refresh setup

.DEFAULT_GOAL := home

DEVICE_FILE := .device
USERNAME := hodduc

ifeq ($(wildcard $(DEVICE_FILE)),)
  HOST := $(shell echo "Error: Run 'make setup' first" >&2; exit 1)
else
  HOST := $(shell cat $(DEVICE_FILE))
endif

# First-time setup: select your device
setup:
	@echo "Available configurations:"
	@echo "  1) macbook-joonsunglee"
	@echo "  2) macstudio-joonsunglee"
	@echo ""
	@read -p "Select: " choice; \
	case $$choice in \
	  1) echo "macbook-joonsunglee" > $(DEVICE_FILE) ;; \
	  2) echo "macstudio-joonsunglee" > $(DEVICE_FILE) ;; \
	  *) echo "Invalid choice"; exit 1 ;; \
	esac
	@echo "Saved to $(DEVICE_FILE): $$(cat $(DEVICE_FILE))"

# Update flake inputs to latest versions
update:
	nix flake update

# Build and apply Darwin system configuration (requires sudo)
darwin:
	darwin-rebuild switch --flake .#$(HOST)

# Build and apply Home Manager configuration (no sudo needed!)
home:
	nix flake update private --allow-dirty-locks
	home-manager switch --flake .#$(USERNAME)@$(HOST)

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
