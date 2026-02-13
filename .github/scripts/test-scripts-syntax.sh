#!/usr/bin/env bash
# Test that shell scripts have valid syntax

set -euo pipefail

echo "::group::Testing script syntax"

EXIT_CODE=0

# Test all shell scripts in home/bin/
if [ -d "$GITHUB_WORKSPACE/home/bin" ]; then
    echo "Checking scripts in home/bin/..."
    while IFS= read -r -d '' script; do
        # Skip non-shell scripts (e.g., Python)
        if head -n1 "$script" | grep -qE '^#!.*python'; then
            echo "Skipping Python script: $script"
            continue
        fi
        
        echo "Checking: $script"
        if bash -n "$script" 2>&1; then
            echo "  ✓ Valid syntax"
        else
            echo "  ✗ Syntax error"
            EXIT_CODE=1
        fi
    done < <(find "$GITHUB_WORKSPACE/home/bin" -type f -name "executable_*" -print0)
fi

# Test install scripts if they exist
for script in "$GITHUB_WORKSPACE/install.sh" "$GITHUB_WORKSPACE/linux/install.sh" "$GITHUB_WORKSPACE/osx/install.sh"; do
    if [ -f "$script" ]; then
        echo "Checking: $script"
        if bash -n "$script" 2>&1; then
            echo "  ✓ Valid syntax"
        else
            echo "  ✗ Syntax error"
            EXIT_CODE=1
        fi
    fi
done

echo "::endgroup::"

exit $EXIT_CODE
