#!/usr/bin/env bash
# Test that file permissions are correct

set -euo pipefail

echo "::group::Testing file permissions"

EXIT_CODE=0

# Test 1: Verify scripts in ~/bin are executable
if [ -d ~/bin ]; then
    echo "Checking executable permissions in ~/bin..."
    
    SCRIPT_COUNT=0
    PERMISSION_ERRORS=0
    
    while IFS= read -r script; do
        SCRIPT_COUNT=$((SCRIPT_COUNT + 1))
        SCRIPT_NAME=$(basename "$script")
        
        if [ -x "$script" ]; then
            echo "  ✓ $SCRIPT_NAME is executable"
        else
            echo "  ✗ $SCRIPT_NAME is not executable"
            PERMISSION_ERRORS=$((PERMISSION_ERRORS + 1))
            EXIT_CODE=1
        fi
    done < <(find ~/bin -type f 2>/dev/null)
    
    if [ $SCRIPT_COUNT -eq 0 ]; then
        echo "⚠ No scripts found in ~/bin"
    else
        echo "Checked $SCRIPT_COUNT script(s), found $PERMISSION_ERRORS permission error(s)"
    fi
else
    echo "⚠ ~/bin directory not found"
fi

# Test 2: Check SSH config permissions (if present)
echo ""
if [ -d ~/.ssh ]; then
    echo "Checking SSH directory permissions..."
    
    # Check ~/.ssh directory permissions (should be 700)
    SSH_DIR_PERMS=$(stat -c '%a' ~/.ssh 2>/dev/null || stat -f '%A' ~/.ssh 2>/dev/null)
    if [ "$SSH_DIR_PERMS" = "700" ]; then
        echo "  ✓ ~/.ssh has correct permissions (700)"
    else
        echo "  ⚠ ~/.ssh has permissions $SSH_DIR_PERMS (expected 700)"
    fi
    
    # Check SSH config file if it exists
    if [ -f ~/.ssh/config ]; then
        CONFIG_PERMS=$(stat -c '%a' ~/.ssh/config 2>/dev/null || stat -f '%A' ~/.ssh/config 2>/dev/null)
        if [ "$CONFIG_PERMS" = "600" ] || [ "$CONFIG_PERMS" = "644" ]; then
            echo "  ✓ ~/.ssh/config has acceptable permissions ($CONFIG_PERMS)"
        else
            echo "  ⚠ ~/.ssh/config has permissions $CONFIG_PERMS (expected 600 or 644)"
        fi
    fi
    
    # Check for private keys with overly permissive permissions
    if compgen -G ~/.ssh/id_* >/dev/null 2>&1; then
        for key in ~/.ssh/id_*; do
            if [ -f "$key" ] && [[ ! "$key" =~ \.pub$ ]]; then
                KEY_PERMS=$(stat -c '%a' "$key" 2>/dev/null || stat -f '%A' "$key" 2>/dev/null)
                KEY_NAME=$(basename "$key")
                if [ "$KEY_PERMS" = "600" ] || [ "$KEY_PERMS" = "400" ]; then
                    echo "  ✓ $KEY_NAME has secure permissions ($KEY_PERMS)"
                else
                    echo "  ⚠ $KEY_NAME has permissions $KEY_PERMS (expected 600 or 400)"
                fi
            fi
        done
    fi
else
    echo "⚠ ~/.ssh directory not found (may not be configured yet)"
fi

# Test 3: Check git hooks are executable (if present)
echo ""
if [ -d ~/.git_hooks ]; then
    echo "Checking git hooks permissions..."
    
    HOOK_COUNT=0
    HOOK_ERRORS=0
    
    for hook in ~/.git_hooks/*; do
        if [ -f "$hook" ]; then
            HOOK_COUNT=$((HOOK_COUNT + 1))
            HOOK_NAME=$(basename "$hook")
            
            if [ -x "$hook" ]; then
                echo "  ✓ $HOOK_NAME is executable"
            else
                echo "  ✗ $HOOK_NAME is not executable"
                HOOK_ERRORS=$((HOOK_ERRORS + 1))
                EXIT_CODE=1
            fi
        fi
    done
    
    if [ $HOOK_COUNT -gt 0 ]; then
        echo "Checked $HOOK_COUNT git hook(s), found $HOOK_ERRORS permission error(s)"
    fi
else
    echo "⚠ ~/.git_hooks directory not found"
fi

echo "::endgroup::"

exit $EXIT_CODE
