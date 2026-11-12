#!/usr/bin/env bash
# Phase 1 preflight (Ubuntu) — Jenkins installation only. Do not delete data.
set -euo pipefail
echo "=== OS ==="; lsb_release -a 2>/dev/null || cat /etc/os-release 2>/dev/null || true
echo; echo "=== Docker ==="; docker --version; docker compose version
echo; echo "=== Existing Jenkins containers ==="; docker ps -a --format '{{.Names}}\t{{.Image}}\t{{.Status}}' | grep -i jenkins || echo "(none)"
echo; echo "=== Jenkins volumes ==="; docker volume ls | grep -i jenkins || echo "(none)"
echo; echo "=== Ports 8080,50000,80,443 ==="; ss -tlnp | grep -E ':(8080|50000|80|443)\s' || echo "(none listening)"
echo; echo "=== Networks ==="; docker network ls | head -20
echo; echo "Review output before proceeding. Do NOT remove existing Jenkins data/containers."