# Traefik integration (Jenkins)

Run Jenkins **after** Traefik is installed and healthy.

## Requirements

- Traefik entrypoints: `web` (80), `websecure` (443)
- Docker provider enabled, `exposedByDefault=false`
- Certificate resolver name matches `.env` (`CERTSRESOLVER=le` for the Traefik setup used here)
- External network: `${DOCKER_PROXY_NETWORK:-proxy}` (default `proxy`)
- DNS: `JENKINS_DOMAIN` points to Traefik host

## Start

```bash
docker network create proxy || true
docker compose -f docker-compose.traefik.yml up -d
docker compose -f docker-compose.traefik.yml logs -f jenkins
```

## Jenkins URL / reverse proxy

After first login, set **Manage Jenkins → System → Jenkins URL** to:
`https://jenkins.devops-odoo.com/` (or your domain).

If you see reverse-proxy warnings, ensure Traefik forwards standard headers and Jenkins is accessed only via HTTPS.

## Security

Do not publish Jenkins port 8080 publicly in Traefik mode. Restrict agent port 50000; prefer WebSocket agents or private networking when possible.
