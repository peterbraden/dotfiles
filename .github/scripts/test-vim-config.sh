#!/usr/bin/env bash
# Test that vim/neovim configurations are valid

set -euo pipefail

echo "::group::Testing vim/neovim configuration"

EXIT_CODE=0

# Test vim configuration
if command -v vim >/dev/null 2>&1; then
    echo "Found vim: $(vim --version | head -n1)"
    
    if [ -f ~/.vimrc ]; then
        echo "Testing vim configuration..."
        
        # Test 1: Check vim starts with the config
        if vim -u ~/.vimrc -c 'echo "Vim config loaded"' -c 'qall' 2>&1 | tee /tmp/vim-test.log; then
            echo "✓ vim starts with config"
        else
            echo "✗ vim failed to start with config"
            cat /tmp/vim-test.log
            EXIT_CODE=1
        fi
        
        # Test 2: Check for basic syntax errors by running a vim command
        if vim -u ~/.vimrc -c 'syntax on' -c 'qall' 2>&1 | tee -a /tmp/vim-test.log; then
            echo "✓ vim config has no critical syntax errors"
        else
            echo "✗ vim config has syntax errors"
            cat /tmp/vim-test.log
            EXIT_CODE=1
        fi
        
        # Test 3: Verify plugin directories exist (submodules)
        if [ -d ~/.vim/external_bundle ]; then
            PLUGIN_COUNT=$(find ~/.vim/external_bundle -mindepth 1 -maxdepth 1 -type d | wc -l)
            echo "Found $PLUGIN_COUNT vim plugins in ~/.vim/external_bundle"
            if [ "$PLUGIN_COUNT" -gt 0 ]; then
                echo "✓ vim plugins directory populated"
            else
                echo "⚠ vim plugins directory empty (submodules may not be initialized)"
            fi
        else
            echo "⚠ ~/.vim/external_bundle not found"
        fi
    else
        echo "⚠ ~/.vimrc not found, skipping vim tests"
    fi
else
    echo "⚠ vim not installed, skipping vim tests"
fi

echo ""

# Test neovim configuration
if command -v nvim >/dev/null 2>&1; then
    echo "Found neovim: $(nvim --version | head -n1)"
    
    if [ -f ~/.config/nvim/init.lua ]; then
        echo "Testing neovim configuration..."
        
        # Test 1: Check neovim starts with the config
        if nvim --headless -u ~/.config/nvim/init.lua -c 'echo "Neovim config loaded"' -c 'qall' 2>&1 | tee /tmp/nvim-test.log; then
            echo "✓ neovim starts with config"
        else
            echo "✗ neovim failed to start with config"
            cat /tmp/nvim-test.log
            EXIT_CODE=1
        fi
        
        # Test 2: Check Lua syntax by loading the config in headless mode
        if nvim --headless -u ~/.config/nvim/init.lua -c 'lua print("OK")' -c 'qall' 2>&1 | tee -a /tmp/nvim-test.log; then
            echo "✓ neovim config has no critical errors"
        else
            echo "✗ neovim config has errors"
            cat /tmp/nvim-test.log
            EXIT_CODE=1
        fi
        
        # Test 3: Verify plugin directories exist
        if [ -d ~/.config/nvim/external_pack ]; then
            PLUGIN_COUNT=$(find ~/.config/nvim/external_pack -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l)
            echo "Found $PLUGIN_COUNT neovim plugin directories in ~/.config/nvim/external_pack"
            if [ "$PLUGIN_COUNT" -gt 0 ]; then
                echo "✓ neovim plugins directory populated"
            else
                echo "⚠ neovim plugins directory empty"
            fi
        else
            echo "⚠ ~/.config/nvim/external_pack not found"
        fi
    elif [ -f ~/.config/nvim/init.vim ]; then
        echo "Testing neovim configuration (vimscript)..."
        
        if nvim --headless -u ~/.config/nvim/init.vim -c 'echo "Neovim config loaded"' -c 'qall' 2>&1 | tee /tmp/nvim-test.log; then
            echo "✓ neovim starts with config"
        else
            echo "✗ neovim failed to start with config"
            cat /tmp/nvim-test.log
            EXIT_CODE=1
        fi
    else
        echo "⚠ neovim config not found, skipping neovim tests"
    fi
else
    echo "⚠ neovim not installed, skipping neovim tests"
fi

echo "::endgroup::"

exit $EXIT_CODE
