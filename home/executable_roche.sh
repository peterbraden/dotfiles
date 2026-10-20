#!/usr/bin/env zsh


# FU docker
alias docker=podman
export TESTCONTAINERS_RYUK_DISABLED=true
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock

alias k=kubectl

# --- ENV ---
export TEST_POSTGRES_IMAGE=postgres:17.5-alpine3.21 # Control Plane API tests requires
export FOXOPS_ACCESS_TOKEN=$(op read op://Personal/Roche/foxops-access-token)
export GITLAB_TOKEN=$(op read op://Personal/Roche/gitlab-token)
export GITLAB_USER=bradenp1
export LINEAR_API_KEY=$(op read op://Personal/Roche/linear-api)
#export AWS_PROFILE='kaiser'
export AWS_PROFILE=fleetmanagement
export VAULT_CLIENT_CERT=/Users/bradenp1/.vault-creds/vault-cert.crt
export VAULT_CLIENT_KEY=/Users/bradenp1/.vault-creds/vault-key.key

# --- Functions and scripts ---

roche_lint_and_fix(){
  poetry run ruff format src/ tests/ alembic/
  poetry run ruff check --fix src/ tests/ alembic/
  poetry run mypy src/ tests/
  poetry run pyright src/ tests/
}

alias flux-bump='flux reconcile source git main && flux get kustomizations -w'

