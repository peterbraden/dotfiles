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

refresh_control_plane(){
  nactl control-plane delete dev-peter
  nactl control-plane delete-ws dev-peter
  nactl control-plane cleanup dev-peter
  nactl control-plane create-ws dev-peter
  nactl control-plane create dev-peter
}

# --- ALIASES ---
#
#
# Personal alias r-aws='navify-aws-sso-login --no-client-cert --username=bradenp1 --write-credentials kaiser --password=$(op read op://Personal/Roche/password) --otp-token=$(op read "op://Personal/Roche/one-time password?attribute=otp")' --login-role-arn arn:aws:iam::789257628895:role/Roche/Platform/Kaiser/KaiserDevOps

# Roche
alias r-aws='navify-aws-sso-login --username=bradenp1 --write-credentials kaiser --password=$(op read op://Personal/Roche/password) --otp-token=$(op read "op://Personal/Roche/one-time password?attribute=otp")' --login-role-arn arn:aws:iam::789257628895:role/Roche/Platform/Kaiser/KaiserDevOps


# Roche
alias r-aws-prod='navify-aws-sso-login --username=bradenp1 --write-credentials kaiser --password=$(op read op://Personal/Roche/password) --otp-token=$(op read "op://Personal/Roche/one-time password?attribute=otp")' --login-role-arn arn:aws:iam::376551651951:role/Roche/Products/NA/NADevOps

alias flux-bump='flux reconcile source git main && flux get kustomizations -w'
