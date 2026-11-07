#!/usr/bin/env bash
# Basic status/health helpers (run from repo root on a Docker host)
set -euo pipefail
echo "== Jenkins containers =="
docker ps --filter "name=jenkins" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' || true
echo
echo "== Jenkins volume =="
docker volume ls --filter name=jenkins_home || true
