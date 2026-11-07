#!/usr/bin/env bash
# Smoke checks after deployment (run on the Docker host).
set -euo pipefail
NAME="${JENKINS_CONTAINER_NAME:-jenkins}"
echo "== container =="
docker ps --filter "name=${NAME}" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
echo "== health =="
docker inspect --format='{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}' "${NAME}" 2>/dev/null || echo "not found"
echo "== initial admin password (if still present) =="
docker exec "${NAME}" cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo "(not available - setup may be complete)"
