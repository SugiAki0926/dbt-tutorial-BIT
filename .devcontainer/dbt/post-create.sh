#!/usr/bin/env bash
set -euo pipefail

cd /workspaces/dbt-tutorial-BIT

uv sync --frozen

uv run dbt --version
