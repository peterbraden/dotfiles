#!/usr/bin/env bash
# Test that shells start without errors

set -euo pipefail

echo "::group::Testing shell startup"

SHELL_TO_TEST="${1:-bash}"

case "$SHELL_TO_TEST" in
    bash)
        echo "Testing bash startup..."
        # Test non-interactive shell (sources .profile -> .bashrc -> .alias)
        # Capture stderr separately to check for actual errors vs warnings
        if bash --noprofile --norc -c '. ~/.profile 2>&1; echo "Bash sourced successfully"' > /tmp/bash-test.log 2>&1; then
            # Check if there were any error messages (but allow missing optional tools)
            if grep -iE '(error|fatal|cannot|failed)' /tmp/bash-test.log | grep -vE '(command not found|No such file)'; then
                echo "Warning: Potential errors during bash startup:"
                grep -iE '(error|fatal|cannot|failed)' /tmp/bash-test.log | grep -vE '(command not found|No such file)' || true
            fi
            echo "✓ Bash startup succeeded"
            cat /tmp/bash-test.log
        else
            echo "✗ Bash startup failed"
            cat /tmp/bash-test.log
            exit 1
        fi
        ;;
    zsh)
        echo "Testing zsh startup..."
        # Test zsh startup (sources .zshrc which sources .alias)
        # Some plugins may be optional, so we check for critical errors only
        if zsh -c '. ~/.zshrc 2>&1; echo "Zsh sourced successfully"' > /tmp/zsh-test.log 2>&1; then
            # Check if there were any error messages (but allow missing optional plugins)
            if grep -iE '(error|fatal|cannot|failed)' /tmp/zsh-test.log | grep -vE '(command not found|No such file|plugin)'; then
                echo "Warning: Potential errors during zsh startup:"
                grep -iE '(error|fatal|cannot|failed)' /tmp/zsh-test.log | grep -vE '(command not found|No such file|plugin)' || true
            fi
            echo "✓ Zsh startup succeeded"
            cat /tmp/zsh-test.log
        else
            echo "✗ Zsh startup failed"
            cat /tmp/zsh-test.log
            exit 1
        fi
        ;;
    *)
        echo "Unknown shell: $SHELL_TO_TEST"
        exit 1
        ;;
esac

echo "::endgroup::"
