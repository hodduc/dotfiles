# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix flake configuration for managing multiple systems using a modular, scalable architecture. The repository is designed to support various operating systems and machine configurations through a unified structure.

## Architecture

### Core Structure

The configuration follows a modular architecture with separated system-level (Darwin) and user-level (Home Manager) configurations:

```
.
├── flake.nix           # Main entry point defining inputs and configurations
├── hosts/              # Host-specific system configurations
│   └── macbook-joonsunglee/
│       └── default.nix # Darwin configuration for this host
├── home/               # User-level Home Manager configurations (portable)
│   ├── default.nix     # Main home-manager entry point
│   ├── programs/       # Program-specific configurations
│   │   ├── git.nix
│   │   └── zsh.nix
│   └── packages.nix    # User packages
└── modules/            # Shared system-level modules
    ├── darwin/         # Darwin-specific modules
    │   ├── system.nix  # macOS system settings
    │   └── macos-defaults.nix
    └── common/         # Cross-platform system settings
        └── nix.nix     # Nix configuration
```

### Design Principles

1. **Separation of System and User**: Darwin manages system-level settings (requires sudo), while Home Manager handles user-level configurations (no sudo needed).

2. **Portability**: Home configurations are designed to work across different platforms and can be applied without administrative privileges.

3. **Modularity**: Each feature is encapsulated in its own module, allowing for easy composition and reuse.

4. **Fast Iteration**: User-level changes can be applied quickly via `make home` without rebuilding the entire system.

## Configuration Management

### System-Level (Darwin)
- **hosts/**: Machine-specific Darwin configurations
- **modules/darwin/**: Shared Darwin modules for macOS system settings
- **modules/common/**: Settings shared across all system types

### User-Level (Home Manager)
- **home/**: Standalone Home Manager configuration
- **home/programs/**: Individual program configurations (git, zsh, etc.)
- **home/packages.nix**: User-installed packages

## Common Commands

```bash
# Update flake inputs to latest versions
make update

# Apply system configuration (requires sudo)
make darwin

# Apply user configuration (no sudo needed!)
make home

# Apply both system and user configurations
make apply

# Clean up old generations and garbage collect
make gc

# Update and rebuild user config only (fast, no sudo!)
make refresh-home

# Update and rebuild system only
make refresh-darwin

# Update and rebuild everything
make refresh
```

## Future Expansion

This repository is designed to grow into a comprehensive dotfiles management system supporting:
- Multiple operating systems (NixOS, Darwin, Linux distributions)
- Different architectures (x86_64, aarch64, etc.)
- Per-machine customizations while maintaining a shared core configuration