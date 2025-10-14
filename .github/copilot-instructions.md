# Copilot Instructions for Dotfiles Repository

## Repository Context

This is a dotfiles repository managed with chezmoi. See `readme.md` for complete overview. Key facts:
- Files in `home/` with `dot_` prefix become dotfiles (e.g., `dot_vimrc` → `~/.vimrc`)
- `.tmpl` suffix indicates chezmoi templates with Go templating for OS-specific logic
- Git submodules in `home/dot_vim/external_bundle/` vendor vim plugins
- Primary workflow: tmux + vim/nvim, optimised for terminal-based development

## When Making Changes

### Chezmoi-Specific Rules
- Preserve chezmoi templating syntax (`{{ if eq .chezmoi.os "darwin" }}`) when present
- File naming: `dot_` prefix, `executable_` for scripts, `.tmpl` for templates
- Don't apply the changes, ask the user to review first.

### Code Changes
- **Minimal modifications only** - these configs have decades of muscle memory
- Never remove or refactor working keybindings, aliases, or shortcuts unless explicitly requested
- Vim leader key is `,` - preserve this in any vim config changes
- Shell aliases must be POSIX-compatible (sourced by both bash and zsh)
- When adding vim plugins: use git submodules in `home/dot_vim/external_bundle/`, following existing pattern

### Testing Changes
- Vim: source the file or restart vim to test
- Shell: source the file (`source ~/.zshrc`) or start new shell
- tmux: `tmux source-file ~/.tmux.conf` or start new session
- Always verify changes don't break existing functionality

## Process

- Before attempting a large task, it's best to plan this out. `plan.md` in a
    repository is the correct place to maintain this document.
    - Always focus on differentiating between assumptions, and what we _know_.

- Don't be afraid to ask questions. Better to clarify my intent, than to spend
    wasted cycles on assumption.

## Documentation

When writing documentation:
- No Americanisms.
- Be as concise and precise as possible.
- Leverage a wide vocabulary - English allows precision through word choice.
- Avoid hyperbole and emotion:
    ie. Instead of "MAJOR BREAKTHROUGH!:" use "Discovery:"
- No emoji or juvenile formatting - we are professionals.
- Inline code is encouraged, but use comments inline rather than many code
    blocks.

ie.

Instead of:

Run command a:
```
command a
```

Run command b:
```
command b
```

It's better to do:

```
# Run command a
command a
# Run command b
command b
```

## Tools and Conventions

- Prefer existing tools over adding new dependencies (Lindy effect philosophy)
- Git submodules for vendoring (keeps tools local, survives link rot)
- Modern replacements on macOS: `eza`, `fd`, `bat`, `rg` (aliased in `dot_alias.tmpl`)
- Shell scripts go in `home/bin/` with `executable_` prefix
- Function over alias over script - see alias file header for rationale
