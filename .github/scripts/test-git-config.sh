#!/usr/bin/env bash
# Test that git configuration is valid

set -euo pipefail

echo "::group::Testing git configuration"

EXIT_CODE=0

# Check if git is available
if ! command -v git >/dev/null 2>&1; then
    echo "⚠ git not installed, skipping git tests"
    echo "::endgroup::"
    exit 0
fi

echo "Found git: $(git --version)"

# Test 1: Verify gitconfig is parseable
if [ -f ~/.gitconfig ]; then
    echo "Testing ~/.gitconfig..."
    
    if git config --file ~/.gitconfig --list >/dev/null 2>&1; then
        echo "✓ ~/.gitconfig is valid and parseable"
    else
        echo "✗ ~/.gitconfig has syntax errors"
        git config --file ~/.gitconfig --list 2>&1 || true
        EXIT_CODE=1
    fi
    
    # Check for accidentally committed sensitive data patterns
    if grep -iE '(password|token|secret|key).*=' ~/.gitconfig 2>/dev/null | grep -v 'signingkey'; then
        echo "⚠ Warning: Potential sensitive data in gitconfig:"
        grep -iE '(password|token|secret|key).*=' ~/.gitconfig | grep -v 'signingkey'
    fi
else
    echo "⚠ ~/.gitconfig not found"
fi

# Test 2: Check global git config (not file-specific)
echo ""
echo "Testing global git configuration..."
if git config --global --list >/dev/null 2>&1; then
    echo "✓ Global git config is accessible"
else
    echo "⚠ Could not read global git config"
fi

# Test 3: Validate git hooks
echo ""
if [ -d ~/.git_hooks ]; then
    echo "Testing git hooks in ~/.git_hooks..."
    
    HOOK_COUNT=0
    HOOK_ERRORS=0
    
    for hook in ~/.git_hooks/*; do
        if [ -f "$hook" ]; then
            HOOK_COUNT=$((HOOK_COUNT + 1))
            HOOK_NAME=$(basename "$hook")
            echo "Checking hook: $HOOK_NAME"
            
            # Check if executable
            if [ -x "$hook" ]; then
                echo "  ✓ Hook is executable"
            else
                echo "  ✗ Hook is not executable"
                EXIT_CODE=1
                HOOK_ERRORS=$((HOOK_ERRORS + 1))
            fi
            
            # Check syntax based on shebang
            SHEBANG=$(head -n1 "$hook")
            if [[ "$SHEBANG" =~ ^#!.*bash ]] || [[ "$SHEBANG" =~ ^#!.*sh ]]; then
                if bash -n "$hook" 2>&1; then
                    echo "  ✓ Shell syntax is valid"
                else
                    echo "  ✗ Shell syntax error"
                    EXIT_CODE=1
                    HOOK_ERRORS=$((HOOK_ERRORS + 1))
                fi
            elif [[ "$SHEBANG" =~ ^#!.*python ]]; then
                if python3 -m py_compile "$hook" 2>&1; then
                    echo "  ✓ Python syntax is valid"
                else
                    echo "  ✗ Python syntax error"
                    EXIT_CODE=1
                    HOOK_ERRORS=$((HOOK_ERRORS + 1))
                fi
            else
                echo "  ⚠ Unknown shebang, skipping syntax check: $SHEBANG"
            fi
        fi
    done
    
    if [ $HOOK_COUNT -eq 0 ]; then
        echo "⚠ No git hooks found in ~/.git_hooks"
    else
        echo "Checked $HOOK_COUNT git hook(s), found $HOOK_ERRORS error(s)"
    fi
else
    echo "⚠ ~/.git_hooks directory not found"
fi

echo "::endgroup::"

exit $EXIT_CODE
