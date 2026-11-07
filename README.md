# Jenkins · Docker Deployment (with Odoo 17/19 integration)

This repository provides a **ready-to-run Jenkins LTS (JDK 21)** deployment via Docker Compose, plus a **separate integration** guide/pattern for CI/CD workflows related to **Odoo 17** and **Odoo 19**.

- **Repo:** https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment
- **Default install path on Ubuntu:** `/opt/jenkins` (see [docs/INSTALL.md](docs/INSTALL.md))
- **Traefik mode:** exposes Jenkins at `https://jenkins.devops-odoo.com` (no public UI port), using Traefik’s external `proxy` network and ACME resolver `le` (align with the Traefik deployment used in this environment).

## Contents

| Path | Purpose |
|---|---|
| `docker-compose.yml` | Standalone Jenkins (HTTP ports 8080/50000 for testing) |
| `docker-compose.traefik.yml` | Jenkins behind Traefik (HTTPS domain, no published UI port) |
| `.env.example` | Configuration template (copy to `.env`, never commit secrets) |
| `jenkins/init.groovy.d/` | Optional Groovy init hooks (no secrets) |
| `IntegrationOdoo/` | Separate Odoo 17/19 CI integration (pipelines, webhook/reverse-proxy notes) |
| `docs/` | Install, Traefik, Odoo integration, operations |
| `scripts/` | Helper scripts (permissions, health checks) |

## Quick start (standalone)

```bash
cp .env.example .env
chmod 600 .env
docker compose up -d
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Open `http://<host>:8080` (or the port in `.env`) and complete setup.

## Quick start (Traefik / HTTPS domain)

Prerequisites: Traefik running, DNS for `jenkins.devops-odoo.com` (or your domain), external network `proxy`.

```bash
cp .env.example .env
# set JENKINS_DOMAIN, CERTSRESOLVER=le, DOCKER_PROXY_NETWORK=proxy
docker network create proxy || true
docker compose -f docker-compose.traefik.yml up -d
```

## Odoo 17 / 19 integration

See [`IntegrationOdoo/README.md`](IntegrationOdoo/README.md) and [`docs/ODOO_INTEGRATION.md`](docs/ODOO_INTEGRATION.md). Integration is **kept separate** from base Jenkins install and assumes Odoo is reachable via its domains (e.g. `https://odoo17.devops-odoo.com`, `https://odoo19.devops-odoo.com`) behind Traefik.

## Security notes

- Do not commit `.env`, tokens, passwords, or `jenkins_home/` data.
- Mounting `/var/run/docker.sock` grants Jenkins powerful host control; use only on trusted CI hosts and restrict job permissions.
- Protect Traefik dashboard and Jenkins with strong auth, HTTPS, and firewall rules.

## License

See `LICENSE.txt`. Jenkins itself is licensed separately by the Jenkins project.
