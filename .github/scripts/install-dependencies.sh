#!/usr/bin/env bash
# Install required dependencies for testing

set -euo pipefail

echo "::group::Installing dependencies"

# Auto-detect OS if not specified
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Check if we're in Alpine (uses apk instead of apt)
    if [ -f /etc/alpine-release ]; then
        OS_TYPE="alpine"
    else
        OS_TYPE="linux"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
else
    echo "Warning: Unknown OS type: $OSTYPE, assuming linux"
    OS_TYPE="linux"
fi

echo "Detected OS: $OS_TYPE"

case "$OS_TYPE" in
    linux)
        echo "Installing Linux dependencies..."
        # Update package lists
        sudo apt-get update -qq
        
        # Install shells
        sudo apt-get install -y -qq bash zsh
        
        # Install basic tools that scripts might depend on
        sudo apt-get install -y -qq \
            git \
            curl \
            tmux \
            vim \
            make \
            ca-certificates
        
        # Install chezmoi
        sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b /usr/local/bin
        ;;
    
    alpine)
        echo "Installing Alpine dependencies..."
        # Update package lists
        apk update
        
        # Install shells (bash and zsh)
        apk add bash zsh
        
        # Install basic tools
        apk add \
            git \
            curl \
            tmux \
            vim \
            make \
            ca-certificates \
            sudo
        
        # Install chezmoi
        sh -c "$(curl -fsLS https://get.chezmoi.io)" -- -b /usr/local/bin
        ;;
    
    macos)
        echo "Installing macOS dependencies..."
        # Homebrew should already be available on GitHub Actions macOS runners
        
        # Install shells (bash and zsh should already be present)
        # Install basic tools
        brew install chezmoi || true
        
        # Ensure tmux and vim are available
        brew install tmux vim || true
        ;;
    
    *)
        echo "Error: Unsupported OS type: $OS_TYPE"
        exit 1
        ;;
esac

# Verify chezmoi is installed
if command -v chezmoi >/dev/null 2>&1; then
    echo "✓ chezmoi installed: $(chezmoi --version)"
else
    echo "✗ chezmoi installation failed"
    exit 1
fi

# Verify shells are available
for shell in bash zsh; do
    if command -v "$shell" >/dev/null 2>&1; then
        echo "✓ $shell available: $($shell --version | head -n1)"
    else
        echo "✗ $shell not available"
        exit 1
    fi
done

echo "::endgroup::"
