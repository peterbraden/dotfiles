# NixOS ISO Builder

Generate a NixOS ISO image in a Docker/Podman container for testing NixOS features.

## Quick Start

```bash
make iso
```

This will:
1. Build a Docker image with Nix and required configuration
2. Create a persistent named container (`nix-iso-builder`)
3. Create persistent volume for flake evaluation cache (if it doesn't exist)
4. Run the container to build the ISO (uses binary cache from cache.nixos.org)
5. Copy the ISO to the current directory with timestamp: `nixos-YYYYMMDD-HHMMSS.iso`

**Important**: The container persists between runs, keeping its `/nix/store` cached!
This means subsequent builds will be MUCH faster as packages won't be re-downloaded.

## Configuration

### Dockerfile
The container is configured with:
- Base image: `ghcr.io/nixos/nix`
- Experimental features enabled (flakes, nix-command)
- Cross-platform support (x86_64-linux, aarch64-linux)
- **Sandbox disabled** - required for Docker/Podman builds
- **Syscall filtering disabled** - prevents seccomp errors on macOS/arm64

### Makefile
The build process uses:
- Platform: `linux/arm64` (aarch64) - optimised for Apple Silicon
- **Named persistent container** (`nix-iso-builder`) - keeps `/nix/store` between builds!
- Privileged mode with security options to avoid seccomp issues
- Volume mount to access flake.nix in current directory
- Security options: `seccomp=unconfined` and `label=disable`
- **Persistent evaluation cache** via named volume `nix-eval-cache`
- **Binary cache** from cache.nixos.org (downloads pre-built packages)

### Persistent Storage

**Named Container** (`nix-iso-builder`):
- The container persists between runs (not deleted after each build)
- Contains full `/nix/store` with all downloaded packages
- Size: Grows with packages (~5-10 GB after first build)
- Impact: HUGE - avoids re-downloading everything on each build
- Inspect: `podman container inspect nix-iso-builder`
- Remove: `make clean-container` (will lose cached packages)

**Evaluation Cache** (`nix-eval-cache` volume):
- Flake lock files and evaluation results
- Downloaded flake inputs  
- Size: ~100-500 MB
- Impact: Faster flake evaluation
- Remove: `make clean-cache`

**Binary Cache** (automatic):
- Nix automatically uses cache.nixos.org
- Downloads pre-built packages instead of building from source
- Only used when package not already in `/nix/store`

**Build times:**
- **First build**: Downloads pre-built packages (~30-60 minutes)
- **Subsequent builds (no changes)**: Uses cached store (~30 seconds!)
- **Configuration changes**: Only downloads NEW packages (~2-5 minutes)
- **After container cleanup**: Back to first build time

**Management:**
- View container: `podman ps -a | grep nix-iso-builder`
- Container size: `podman container inspect nix-iso-builder --format '{{.SizeRootFs}}'`
- Remove container: `make clean-container`
- Remove everything: `make clean-all`

## Customisation

Edit `flake.nix` to customise the ISO:
- Add packages to `environment.systemPackages`
- Configure SSH keys in `users.users.root.openssh.authorizedKeys.keys`
- Adjust system settings as needed

## Build Time

First build: 30-60 minutes (downloads and builds all dependencies)
Subsequent builds: Much faster (uses Nix cache)

## Troubleshooting

### seccomp BPF errors
If you see `unable to load seccomp BPF program: Invalid argument`:
- Ensure `filter-syscalls = false` is in Dockerfile's nix.conf
- Ensure `--option filter-syscalls false` is in the build command
- These changes are already applied in this configuration

### Platform compatibility
This ISO is built for **aarch64/ARM64** architecture and will work on:
- Apple Silicon VMs (UTM, Parallels, VMware Fusion)
- ARM-based cloud instances (AWS Graviton, Oracle Ampere, etc.)
- Raspberry Pi 4/5 and other ARM SBCs

For x86_64/Intel systems, change `system = "aarch64-linux"` to `"x86_64-linux"` in flake.nix and `--platform linux/arm64` to `linux/amd64` in Makefile.

### Out of space
ISO builds require significant disk space (~10GB+). Ensure Docker/Podman has adequate storage allocated.

The persistent container will grow with cached packages (~5-10 GB). If you need to reclaim space:
```bash
make clean-container  # Remove container (loses package cache)
make clean-cache      # Remove evaluation cache volume
make clean-all        # Remove everything
```

## Available Commands

- `make iso` - Build the NixOS ISO (creates/reuses persistent container)
- `make rebuild` - Rebuild in existing container (very fast if packages cached)
- `make clean-cache` - Remove the evaluation cache volume
- `make clean-container` - Remove the persistent container (loses package cache)
- `make clean-all` - Remove both container and cache volumes
- `make clean-iso` - Remove generated ISO files from current directory

## Testing the ISO

Once built, the ISO will be in the current directory with a timestamp:
```bash
ls -lh nixos-*.iso
```

Test with:
- VirtualBox, VMware, or UTM
- Write to USB drive: `dd if=nixos-*.iso of=/dev/sdX bs=4M status=progress`
- QEMU: `qemu-system-aarch64 -m 2048 -cdrom nixos-*.iso`
