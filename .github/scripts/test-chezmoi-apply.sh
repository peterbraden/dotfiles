#!/usr/bin/env bash
# Test that chezmoi apply works without errors

set -euo pipefail

echo "::group::Testing chezmoi apply"

# Initialise chezmoi with test data
export HOME="${HOME:-/tmp/test-home}"
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
chezmoi init --source="$GITHUB_WORKSPACE"

echo "Applying dotfiles..."
if chezmoi apply --verbose 2>&1 | tee /tmp/chezmoi-apply.log; then
    echo "✓ chezmoi apply succeeded"
else
    echo "✗ chezmoi apply failed"
    cat /tmp/chezmoi-apply.log
    exit 1
fi

echo "::endgroup::"
