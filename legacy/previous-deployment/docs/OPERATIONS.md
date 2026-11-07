# Operations

Run commands from the repo root (e.g. `/opt/jenkins`).

## Common commands

| Action | Command |
|---|---|
| Validate (standalone) | `docker compose config` |
| Start standalone | `docker compose up -d` |
| Validate (Traefik) | `docker compose -f docker-compose.traefik.yml config` |
| Start Traefik mode | `docker compose -f docker-compose.traefik.yml up -d` |
| Status | `docker compose ps` / `docker compose -f docker-compose.traefik.yml ps` |
| Logs | `docker compose logs -f jenkins` |
| Verify | `bash scripts/verify.sh` |
| Stop (keep data) | `docker compose down` |
| Restart | `docker compose restart jenkins` |

## Backup / restore

Backup `jenkins_home` before upgrades:

```bash
docker run --rm -v jenkins_home:/data -v "$(pwd)":/backup alpine \
  tar czf /backup/jenkins_home_$(date +%F).tgz -C /data .
```

Restore only to an empty/new volume with Jenkins stopped. Test restores.

## Upgrades

1. Backup `jenkins_home`.
2. Update `JENKINS_IMAGE` in `.env` if needed.
3. `docker compose pull && docker compose up -d` (or Traefik compose variant).
4. Verify UI, jobs, agents, and Odoo integration credentials.

## UID/GID note

The compose runs Jenkins as `${JENKINS_UID}:${JENKINS_GID}` (default `1000:1000`). If the `jenkins_home` volume has permission issues on a new host, check ownership inside the volume or align UID/GID to the host user (advanced; handle carefully).

## Docker socket

`/var/run/docker.sock` is mounted for CI jobs that build/run Docker. This grants high privilege to Jenkins jobs—use only on trusted hosts and restrict who can configure pipelines/credentials.
