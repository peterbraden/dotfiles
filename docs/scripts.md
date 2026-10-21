# Scripts in `~/bin`

chezmoi installs these from [`home/bin`](../home/bin) to `~/bin`, which is on
`PATH` on every host. Bash-first with no external dependencies unless noted;
the Python ones run with [`uv`](https://docs.astral.sh/uv/) (installed by the
install script).

Work-only scripts (`absent-days`, `daily-summary`, `gl-cat`, `gl-ls`,
`gl-file-append`, `my-issues`, `update-plan`) are only deployed where
`work = true`. Tokens they need come from the 1Password Environment at
`~/roche.env`, which the work profile loads into interactive shells.

## Task workflow

A typical workflow for picking up a task, working on it, and finishing:

```
task-start myapp "Fix auth bug"    # create worktree, branch, plan.md, tmux session
# ... work on the task ...
plan                               # toggle plan.md pane to track progress
tasks                              # switch between active projects
task-complete                      # assert clean, revert plan, tear down worktree
```

For longer-lived work or full repo clones, use `open-project` / `close-project` instead.

### task-start

Creates a worktree-based workspace for a task. Resolves the repo (cloning if needed), creates a git worktree from the default branch, seeds `plan.md`, and opens a tmux session. Uses `gum` for interactive prompts when args are omitted.

```bash
task-start                                     # interactive (gum prompts)
task-start myapp "Fix auth bug"                # positional args
task-start --repo myapp --branch pb/fix-auth   # explicit branch
task-start --repo myapp --description "Fix X"  # auto-generates branch
```

Worktrees are created at `~/repos/worktrees/<repo>--<branch-slug>`.

### task-complete

Finishes a worktree-based task cleanly. Run from inside the worktree.

Asserts all changes are committed and pushed, reverts `plan.md` to its base-branch state, removes the worktree, deletes the local branch, and kills the tmux session. Leaves the remote branch for the MR.

```bash
task-complete                          # finish the current task
```

### task-stop

Abandons or pauses a worktree-based task. Run from inside the worktree.

Kills the tmux session and removes the worktree without checking for uncommitted changes. Keeps the branch for later.

```bash
task-stop                              # stop with confirmation prompt
task-stop --force                      # skip confirmation
```

### open-project

Opens or reattaches to a tmux session for a project. Looks in `~/repos/<name>`, cloning from github if the directory doesn't exist. Creates a session with 3 windows. Uses `switch-client` when already inside tmux to avoid nesting.

```bash
open-project myapp                     # open or reattach
open-project new myapp                 # clone a fresh copy as myapp-1 (or -2, etc)
open-project new myapp "Adding bar"    # clone, seed plan.md, and open
```

### close-project

Closes a tmux session for a project.

```bash
close-project myapp                    # close named session
close-project                          # close current session (inside tmux)
```

### tasks

Shows all projects, worktrees, and tmux sessions with their branch, git status, and plan summary. Grouped by type:

- **Sessions** (cyan) — active tmux sessions, `*` marks current
- **Worktrees** (green, `⚙`) — worktrees without a session
- **Repos** (blue) — inactive repos

With `--choose`, opens an fzf picker to switch to or open a project. Inside tmux uses a popup; outside runs fzf inline. Requires fzf for `--choose`.

```bash
tasks                                  # list everything
tasks --choose                         # interactive picker
tasks -c                               # short form
```

### plan

Toggles a `plan.md` pane in the current tmux window. The pane live-renders the file with ANSI syntax highlighting and refreshes when it changes.

```bash
plan                                   # toggle plan pane on/off
```

## Automation

### update-plan (work only)

Refreshes `~/.plan` with a concise summary of current work. Gathers context from `my-issues`, `daily-summary`, and `tasks`, then uses an LLM to synthesize a structured markdown plan grouped by workstream. Safe to run from cron — failures leave `~/.plan` untouched. Reads its tokens from `~/roche.env`; if 1Password is locked it gives up after 5 seconds and keeps the previous plan.

Supports multiple GitHub tokens: any `GITHUB_TOKEN*` env vars are collected, and `my-issues` runs once per token with results merged and deduplicated.

```bash
update-plan                            # manual run
```

Cron (every 5 minutes):
```
*/5 * * * * $HOME/bin/update-plan 2>> /tmp/update-plan.log
```

### llm

Send a prompt to an LLM and print the response. Wraps `claude -p` so other scripts stay provider-agnostic.

```bash
llm "What is 2+2?"                     # argument
echo "Summarize this" | llm            # stdin
LLM_MODEL=sonnet llm "Complex task"    # override model
```

## Status and reporting

### my-issues (work only)

Shows your open Linear issues, GitLab MRs, and GitHub PRs in a table, grouped by status. Includes MRs/PRs authored by you and assigned to you for review. Correlates MRs with tickets by matching identifiers in branch names and MR titles. Requires `LINEAR_API_KEY` and optionally `GITLAB_TOKEN`, `GITHUB_TOKEN`.

```bash
my-issues                              # all open issues + MRs
my-issues -t NAFM                      # filter by team
my-issues -w                           # watch mode (60s refresh)
```

### daily-summary (work only)

Summarizes your day's activity from Linear, GitLab, GitHub, and local git repos. Shows completed/in-progress tickets with status transitions, merged/open MRs/PRs (authored and assigned for review) with pipeline and approval info, and commits with line stats.

```bash
daily-summary                          # today
daily-summary --since 2d               # last 2 days
daily-summary --repos-dir ~/work       # scan different directory
```

### team-summary

Shows what your team members are working on today. Fetches each member's recently updated Linear issues in parallel.

```bash
team-summary                           # Fleet Management team, today
team-summary -t NA                     # different team
team-summary --since 2d                # last 2 days
```

### flux-status

Shows reconciling Flux Kustomizations in a table. Requires `kubectl` configured with a cluster context.

```bash
flux-status                            # show reconciling kustomizations
flux-status -w                         # watch mode (5s refresh)
flux-status -n flux                    # filter by namespace
```

### pod-status

Shows failing pods in the cluster. Detects CrashLoopBackOff, ImagePullBackOff, OOMKilled, Error, init failures, and unschedulable pods.

```bash
pod-status                             # show failing pods
pod-status -w                          # watch mode (5s refresh)
pod-status -n kube-system              # filter by namespace
pod-status --all                       # show all pods including healthy
```

## Remote file operations

Read, list, and append to files on GitHub or GitLab without cloning. All scripts share the same `owner/repo` positional pattern and `--branch` flag.

GitHub scripts use `GITHUB_TOKEN_PERSONAL` (falling back to `GITHUB_TOKEN`). GitLab scripts use `GITLAB_TOKEN` and `GITLAB_HOST`. Both are optional environment variables (on work machines they come from `~/roche.env`): without them the `gl-*` scripts fail and the summaries skip GitLab.

### gh-cat / gl-cat (gl-* work only)

Print file contents to stdout.

```bash
gh-cat myorg/myrepo README.md
gh-cat myorg/myrepo src/main.go --branch develop
gl-cat mygroup/myrepo config.json | jq .
```

### gh-ls / gl-ls (gl-* work only)

List directory contents.

```bash
gh-ls myorg/myrepo                     # list repo root
gh-ls myorg/myrepo src -l              # long format (type, size, name)
gl-ls mygroup/myrepo --branch develop
```

### gh-file-append / gl-file-append (gl-* work only)

Append text to a file and commit. By default commits directly to the default branch. With `--pr`, creates a new branch and opens a pull request / merge request.

```bash
gh-file-append myorg/myrepo CHANGELOG.md "\n- fix: typo"
gh-file-append myorg/myrepo docs/notes.md "deployed" --pr
gl-file-append mygroup/myrepo docs/notes.md "deployed" --pr --title "Add note"
echo "new entry" | gh-file-append myorg/myrepo README.md -
```

## Notifications

### telegram-notify

Sends a push notification to your phone via a Telegram bot. Requires `TELEGRAM_BOT_TOKEN` and `TELEGRAM_CHAT_ID`.

```bash
telegram-notify "Build passed"
telegram-notify -t "CI" "All checks green"
make test && telegram-notify "Tests passed"
```

### telegram-receive

Waits for a Telegram message and prints it to stdout. Uses long-polling, no busy loop.

```bash
telegram-receive                       # wait up to 30s (default)
telegram-receive --poll 60             # wait up to 60s
reply=$(telegram-receive --poll 120)   # capture reply
```

## Supporting scripts

Building blocks used by the workflow scripts above. Useful on their own too.

### find-or-clone

Resolves a repo in `~/repos`, cloning from `GIT_CLONE_BASE` if it doesn't exist. Prints the absolute path.

```bash
find-or-clone myapp                    # find or clone, print path
find-or-clone myapp myapp-2            # clone into a specific directory name
```

### tmux-session

Starts or attaches to a tmux session with 3 windows for a directory.

```bash
tmux-session myapp ~/repos/myapp       # start or attach
tmux-session myapp ~/repos/myapp --no-attach  # create without attaching
```

### seed-plan

Creates a `plan.md` in a directory from a task description. Skips if the file already exists.

```bash
seed-plan ~/repos/myapp "Fix auth bug"
```

### plan-oneline

Prints the first line of `plan.md` with the heading prefix stripped. Walks up the directory tree to find the file. Outputs nothing if no `plan.md` exists.

```bash
plan-oneline                           # e.g. "Refactor auth layer"
```

### plan-find

Walks up the directory tree from the current directory to find `plan.md`. Prints the absolute path if found, exits silently if not. Used internally by `plan` and `plan-oneline`.

```bash
plan-find                              # e.g. /Users/me/repos/myapp/plan.md
```

### plan-render

Watches `plan.md` for changes (mtime polling, 2s interval) and renders it with ANSI colouring. Headings in blue/cyan, checked items in green, unchecked in white. Not called directly — runs inside the pane created by `plan`.

### tmux-tree

Toggles a sidebar showing a tree of all tmux sessions, windows, panes, and their running processes. Auto-refreshes when state changes. Bind to a tmux key (e.g. `bind t run-shell 'tmux-tree'`).

```bash
tmux-tree                              # toggle tree sidebar on/off
```

### tml

Pretty tmux session list with color-coded backgrounds (green = current, blue = attached, gray = detached), git branch, window count, and working directory.

```bash
tml                                    # list sessions
```

## Other

### brew-extras

Shows brew packages you've installed that aren't in your dotfiles install script. Reads the install template from the local chezmoi source (or `--url`) and diffs against `brew list`.

```bash
brew-extras                            # show manually installed packages
brew-extras --missing                  # also show dotfiles packages not installed
brew-extras --all                      # show extras, missing, and shared
brew-extras --url https://...          # use a different install script URL
```

### pong

Play pong vs AI while waiting for a job to finish. When the job succeeds, fireworks and "You Win!". Propagates the job's exit code.

```bash
pong                                   # just play
pong --wait-for "make test"            # play while waiting
pong --wait-for "kubectl rollout ..."  # play while waiting for rollout
```

### hello

Prints a message in rainbow colors using ANSI 256-color codes.

```bash
hello                                  # default message
hello "your message here"              # custom message
```
