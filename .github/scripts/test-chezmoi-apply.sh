#!/usr/bin/env bash
# Test that chezmoi apply works without errors

set -euo pipefail

echo "::group::Testing chezmoi apply"

# Initialise chezmoi with test data
# Use actual HOME in CI - the runner HOME is ephemeral and safe to use
mkdir -p "$HOME"

# Create minimal config to avoid interactive prompts
mkdir -p "$HOME/.config/chezmoi"
cat > "$HOME/.config/chezmoi/chezmoi.toml" <<EOF
[data]
    work = false
    golang = false
    nodejs = false
    rust = false
    python = false
EOF

echo "Initializing chezmoi..."
# Create the source directory and copy the repository there
mkdir -p "$HOME/.local/share/chezmoi"
cp -r "$GITHUB_WORKSPACE/home/." "$HOME/.local/share/chezmoi/"
# Copy metadata files
cp "$GITHUB_WORKSPACE/.chezmoiroot" "$HOME/.local/share/chezmoi/" 2>/dev/null || true

echo "Applying dotfiles..."
if chezmoi apply --verbose 2>&1 | tee /tmp/chezmoi-apply.log; then
    echo "✓ chezmoi apply succeeded"
else
    echo "✗ chezmoi apply failed"
    cat /tmp/chezmoi-apply.log
    exit 1
fi

echo "::endgroup::"
