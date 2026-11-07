#!/usr/bin/env bash
# Phase 1 verification (Ubuntu). Captures evidence for INSTALLATION_REPORT.md. Does NOT delete data.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT="${1:-verify-output.txt}"
exec > >(tee "$OUT") 2>&1
echo "# Phase 1 verify $(date -Is)"
echo "## config"; docker compose config --quiet && echo OK
echo "## up"; docker compose up -d
echo "## wait/ps"; sleep 15; docker compose ps
echo "## container state"; docker inspect --format 'status={{.State.Status}} health={{if .State.Health}}{{.State.Health.Status}}{{else}}n/a{{end}}' "${JENKINS_CONTAINER_NAME:-jenkins}"
echo "## UI check"; docker exec "${JENKINS_CONTAINER_NAME:-jenkins}" curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
echo "## initial password (first run only)"; docker exec "${JENKINS_CONTAINER_NAME:-jenkins}" sh -c 'cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || echo ALREADY_INITIALIZED_OR_NOT_READY'
echo "## persistence marker"; docker exec "${JENKINS_CONTAINER_NAME:-jenkins}" sh -c 'date -Is > /var/jenkins_home/.p1-persist-test && cat /var/jenkins_home/.p1-persist-test'
echo "## restart"; docker compose restart; sleep 20; docker compose ps
echo "## persistence verify"; docker exec "${JENKINS_CONTAINER_NAME:-jenkins}" cat /var/jenkins_home/.p1-persist-test
echo "## volume"; docker volume inspect jenkins_home --format '{{.Name}} {{.Mountpoint}}'
echo "## logs tail (check critical errors)"; docker compose logs --tail=80 jenkins || true
echo "## DONE - review output, then update ../../INSTALLATION_REPORT.md with actual results"