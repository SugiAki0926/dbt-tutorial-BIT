#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/dbt-tutorial-BIT

uv sync --frozen

# Keep host credentials read-only and adapt macOS key paths for the container.
mkdir -p "$DBT_PROFILES_DIR"
sed -E \
  's#^([[:space:]]*private_key_path:[[:space:]]*).*/([^/]+)$#\1/root/.ssh/\2#' \
  /root/.dbt-host/profiles.yml > "$DBT_PROFILES_DIR/profiles.yml"
chmod 600 "$DBT_PROFILES_DIR/profiles.yml"

uv run dbt --version
