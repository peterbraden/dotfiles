#!/usr/bin/env bash
# Test that tmux configuration is valid

set -euo pipefail

echo "::group::Testing tmux configuration"

EXIT_CODE=0

# Check if tmux is available
if ! command -v tmux >/dev/null 2>&1; then
    echo "⚠ tmux not installed, skipping tmux tests"
    echo "::endgroup::"
    exit 0
fi

echo "Found tmux: $(tmux -V)"

# Check if tmux config exists
if [ ! -f ~/.tmux.conf ]; then
    echo "✗ ~/.tmux.conf not found"
    EXIT_CODE=1
else
    echo "✓ ~/.tmux.conf exists"
    
    # Test tmux config syntax by starting a detached session with the config
    # We create a temporary session and immediately kill it
    SESSION_NAME="test-config-$$"
    
    echo "Testing tmux configuration loads without errors..."
    if tmux -f ~/.tmux.conf new-session -d -s "$SESSION_NAME" 2>&1 | tee /tmp/tmux-test.log; then
        echo "✓ tmux session created successfully"
        
        # Source the config file in the running session to catch any runtime errors
        if tmux -f ~/.tmux.conf source-file ~/.tmux.conf 2>&1 | tee -a /tmp/tmux-test.log; then
            echo "✓ tmux config sources without errors"
        else
            echo "✗ tmux config has errors when sourcing"
            cat /tmp/tmux-test.log
            EXIT_CODE=1
        fi
        
        # Clean up test session
        tmux kill-session -t "$SESSION_NAME" 2>/dev/null || true
    else
        echo "✗ tmux failed to start with config"
        cat /tmp/tmux-test.log
        EXIT_CODE=1
    fi
fi

echo "::endgroup::"

exit $EXIT_CODE
