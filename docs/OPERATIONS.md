# Operations

## Common commands (from `/opt/jenkins`)

| Action | Command |
|---|---|
| Start standalone | `docker compose up -d` |
| Start Traefik mode | `docker compose -f docker-compose.traefik.yml up -d` |
| Status | `docker compose ps` or `docker compose -f docker-compose.traefik.yml ps` |
| Logs | `docker compose logs -f jenkins` |
| Stop (keep data) | `docker compose down` |
| Restart | `docker compose restart jenkins` |

## Backup / restore

Backup the `jenkins_home` volume regularly:

```bash
docker run --rm -v jenkins_home:/data -v "$(pwd)":/backup alpine \
  tar czf /backup/jenkins_home_$(date +%F).tgz -C /data .
```

Restore to an **empty** volume after stopping Jenkins. Test restores.

## Upgrades

1. Backup `jenkins_home`.
2. `docker compose pull` (or update image tag in `.env`).
3. `docker compose up -d`.
4. Verify plugins/jobs and agent connectivity.

## Troubleshooting

- Permission issues: ensure volume ownership matches Jenkins user (uid/gid in `.env`).
- Reverse proxy issues: set Jenkins URL to HTTPS domain; check Traefik router/service labels and logs.
- Docker-in-Jenkins jobs: confirm socket mount is intended and secure.
