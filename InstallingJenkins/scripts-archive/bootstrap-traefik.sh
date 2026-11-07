#!/usr/bin/env bash
# Optional helper for Traefik mode (Linux). Requires Traefik + proxy network + DNS.
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ ! -f .env ]]; then
  cp .env.example .env
  chmod 600 .env
  echo "Created .env - set JENKINS_DOMAIN/CERTSRESOLVER/DOCKER_PROXY_NETWORK before use."
fi
docker network create "${DOCKER_PROXY_NETWORK:-proxy}" 2>/dev/null || true
docker compose -f docker-compose.traefik.yml config >/dev/null
echo "Traefik compose config OK"
docker compose -f docker-compose.traefik.yml up -d
docker compose -f docker-compose.traefik.yml ps
