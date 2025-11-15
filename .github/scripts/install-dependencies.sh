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
        
        # Install chezmoi - download binary directly from GitHub releases
        CHEZMOI_VERSION=$(curl -sL https://github.com/twpayne/chezmoi/releases/latest | grep -o 'tag/v[0-9.]*' | head -1 | cut -d'/' -f2 | tr -d 'v')
        curl -sL "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_amd64.tar.gz" | tar -xz -C /tmp
        sudo mv /tmp/chezmoi /usr/local/bin/
        sudo chmod +x /usr/local/bin/chezmoi
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
        
        # Install chezmoi - download binary directly from GitHub releases
        CHEZMOI_VERSION=$(curl -sL https://github.com/twpayne/chezmoi/releases/latest | grep -o 'tag/v[0-9.]*' | head -1 | cut -d'/' -f2 | tr -d 'v')
        curl -sL "https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}/chezmoi_${CHEZMOI_VERSION}_linux_amd64.tar.gz" | tar -xz -C /tmp
        sudo mv /tmp/chezmoi /usr/local/bin/
        sudo chmod +x /usr/local/bin/chezmoi
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
