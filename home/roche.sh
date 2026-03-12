#!/usr/bin/env zsh

# FU docker
alias docker=podman
export TESTCONTAINERS_RYUK_DISABLED=true
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

alias k=kubectl

# --- ENV ---
export TEST_POSTGRES_IMAGE=postgres:17.5-alpine3.21 # Control Plane API tests requires
export GITLAB_TOKEN=$(op read op://Personal/Roche/gitlab-token)
export FOXOPS_ACCESS_TOKEN=$(op read op://Personal/Roche/foxops-access-token)

export OPENAI_API_BASE=https://api.githubcopilot.com
export OPENAI_API_KEY=$(op read op://Personal/Roche/github-copilot-token)

export GITHUB_TOKEN=$(op read op://Personal/Roche/github-token)

export COPILOT_API_BASE_URL=https://api.githubcopilot.com
export COPILOT_API_KEY=$(op read op://Personal/Roche/github-copilot-token-no-prefix)

export AWS_PROFILE='kaiser'

# --- Functions and scripts ---

roche_lint_and_fix(){
  poetry run ruff format src/ tests/ alembic/
  poetry run ruff check --fix src/ tests/ alembic/
  poetry run mypy src/ tests/
  poetry run pyright src/ tests/
}

alias flux-bump='flux reconcile source git main && flux get kustomizations -w'

