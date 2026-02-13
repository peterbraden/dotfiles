#!/usr/bin/env bash
# Test that rendered config files are valid

set -euo pipefail

echo "::group::Testing rendered configuration files"

EXIT_CODE=0

# Test rendered shell configs exist and are non-empty
for config in ~/.profile ~/.bashrc ~/.alias; do
    if [ -f "$config" ]; then
        echo "Checking: $config"
        if [ -s "$config" ]; then
            echo "  ✓ File exists and is non-empty"
            # Verify it's valid shell syntax
            if bash -n "$config" 2>&1; then
                echo "  ✓ Valid shell syntax"
            else
                echo "  ✗ Invalid shell syntax"
                EXIT_CODE=1
            fi
        else
            echo "  ✗ File is empty"
            EXIT_CODE=1
        fi
    else
        echo "Warning: $config not found (may be optional)"
    fi
done

# Test zsh config if zsh is available
if command -v zsh >/dev/null 2>&1 && [ -f ~/.zshrc ]; then
    echo "Checking: ~/.zshrc"
    if [ -s ~/.zshrc ]; then
        echo "  ✓ File exists and is non-empty"
        # Zsh syntax checking (basic)
        if zsh -n ~/.zshrc 2>&1; then
            echo "  ✓ Valid zsh syntax"
        else
            echo "  ✗ Invalid zsh syntax"
            EXIT_CODE=1
        fi
    else
        echo "  ✗ File is empty"
        EXIT_CODE=1
    fi
fi

# Test that bin directory scripts were installed
if [ -d ~/bin ]; then
    SCRIPT_COUNT=$(find ~/bin -type f | wc -l)
    echo "Found $SCRIPT_COUNT scripts in ~/bin"
    if [ "$SCRIPT_COUNT" -gt 0 ]; then
        echo "  ✓ Scripts installed"
    else
        echo "  ✗ No scripts found"
        EXIT_CODE=1
    fi
else
    echo "  ✗ ~/bin directory not created"
    EXIT_CODE=1
fi

echo "::endgroup::"

exit $EXIT_CODE
