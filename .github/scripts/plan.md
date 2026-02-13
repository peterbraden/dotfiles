# CI Test Coverage Enhancement Plan

## Current State

The portability test suite currently validates:
- ✓ Script syntax (bash -n)
- ✓ Chezmoi apply succeeds
- ✓ Bash/zsh startup without errors
- ✓ Rendered configs are non-empty and syntactically valid
- ✓ Tests on Ubuntu 22.04, 24.04, macOS

## Proposed Enhancements

### High Priority

#### 1. Tmux Configuration Validation
**Why**: Tmux is critical to workflow; config errors would be immediately apparent
**Implementation**:
```bash
tmux -f ~/.tmux.conf source-file ~/.tmux.conf
```
**Notes**: May need to handle cases where tmux server is already running

#### 2. Vim/Neovim Configuration Validation
**Why**: Primary editor; config errors break development flow
**Implementation**:
- Check vim config syntax: `vim -u ~/.vimrc +qall`
- Test vim starts without errors: `vim -u ~/.vimrc -c 'echo "OK"' -c 'qall'`
- Verify vim plugins checked out (submodules in `dot_vim/external_bundle/`)
**Notes**: Need to handle both vim and nvim configs

#### 3. Template Rendering Tests
**Why**: Templates use OS-specific logic; errors may only appear on certain platforms
**Implementation**:
- Test with multiple feature flag combinations (golang, nodejs, rust, python, work)
- Verify templates render without errors: `chezmoi execute-template`
- Test each OS path (darwin, linux)
**Notes**: Critical for catching Go template syntax errors

#### 4. Idempotency Check
**Why**: Fundamental property of dotfiles - applying twice shouldn't cause changes
**Implementation**:
```bash
chezmoi apply
chezmoi diff  # should be empty
```
**Notes**: Ensures no unintended side effects or timestamp issues

### Medium Priority

#### 5. Git Configuration Validation
**Why**: Git config errors break version control operations
**Implementation**:
- Verify gitconfig is valid: `git config --file ~/.gitconfig --list`
- Test git hooks are executable and have valid syntax
- Check for accidentally committed sensitive data (tokens, passwords)
**Notes**: Git hooks in `dot_git_hooks/` need syntax validation

#### 6. Python Script Validation
**Why**: Several utility scripts are Python-based
**Implementation**:
- Check Python syntax: `python3 -m py_compile script.py`
- Basic imports test (verify dependencies available)
**Files**: `executable_list-aws-services.py`, `executable_todos.py`

#### 7. Integration Tests
**Why**: Ensures tools actually work, not just parse
**Implementation**:
- Test PATH contains expected directories
- Verify aliases are defined and functional (sample a few critical ones)
- Test key functions work (e.g., git_branch helper)
**Notes**: Keep lightweight; avoid testing external services

#### 8. File Permissions Check
**Why**: Wrong permissions break scripts and security
**Implementation**:
- Verify executable scripts have +x
- Check SSH config has appropriate permissions (600/700)
- Verify git hooks are executable
**Notes**: Particularly important for scripts in `bin/`

### Lower Priority

#### 9. Link/Reference Validation
**Why**: Broken references cause runtime errors
**Implementation**:
- Check that sourced files exist (all `. ~/.alias` type references)
- Verify relative paths in configs are valid
- Check submodule URLs are accessible
**Notes**: Some overlap with existing tests

#### 10. Extended OS Coverage
**Why**: Catch distribution-specific issues
**Candidates**:
- Debian (different apt behaviour)
- Fedora/RHEL (RPM-based systems)
- Alpine (minimal environment, busybox defaults)
**Notes**: Consider maintenance cost vs benefit; current Ubuntu/macOS covers most cases

## Implementation Strategy

1. Start with high-priority items that provide most value
2. Each enhancement gets its own script in `.github/scripts/`
3. Add corresponding step to `portability.yml` workflow
4. Ensure tests fail fast but provide useful diagnostics
5. Keep scripts portable (POSIX where possible)

## Open Questions

1. **Vim plugins**: Should we test that vim plugins actually load, or just that they're checked out?
   - Pro: Catches plugin errors
   - Con: Slow, plugins may have external dependencies

2. **Template combinations**: How many combinations to test?
   - All features enabled
   - All features disabled
   - Individual features (8 combinations for boolean flags)
   - Per-OS variations (multiply by 2)
   - Total: Could be 16+ combinations

3. **Python dependencies**: Should CI install boto3 for AWS scripts?
   - Or just syntax check without import testing?

4. **Integration depth**: How deep should integration tests go?
   - Just verify commands exist?
   - Actually execute and check output?

## Success Criteria

- Tests catch regressions before they reach production machines
- Test execution time remains reasonable (<5 minutes per OS)
- False positives minimised (tests don't fail on working configs)
- Clear error messages when tests fail
- Maintainable - easy to add new tests as configs evolve
