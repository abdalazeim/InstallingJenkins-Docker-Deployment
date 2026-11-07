#!/usr/bin/env bash
# Optional helper for Linux testing. Creates .env from template if missing.
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ ! -f .env ]]; then
  cp .env.example .env
  chmod 600 .env
  echo "Created .env from .env.example - review it before production."
fi
docker compose config >/dev/null
echo "Compose config OK"
docker compose up -d
docker compose ps
