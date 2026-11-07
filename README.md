# Installing Jenkins · Docker Deployment

**Jenkins LTS (JDK 21) + Docker Compose · Ubuntu/Linux · Optional Traefik HTTPS · Odoo 17/19 CI integration**

Repository: https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment

This project deploys Jenkins with persistent data (`jenkins_home` volume). It supports:
- **Standalone mode** (HTTP ports for testing/lab)
- **Traefik mode** (HTTPS domain, no public Jenkins UI port; Traefik terminates TLS)
- **Separate Odoo integration** (`IntegrationOdoo/`) for CI/CD patterns targeting Odoo 17/19 behind Traefik.

## Recommended install path

On Ubuntu, install under **`/opt/jenkins`**:

```bash
sudo mkdir -p /opt/jenkins
sudo chown "$USER":"$USER" /opt/jenkins
git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/jenkins
cd /opt/jenkins
```

## Files

| File/Folder | Purpose |
|---|---|
| `docker-compose.yml` | Standalone Jenkins (8080/50000 by default) |
| `docker-compose.traefik.yml` | Jenkins behind Traefik (HTTPS) |
| `.env.example` | Config template — copy to `.env`, **never commit secrets** |
| `IntegrationOdoo/` | Odoo 17/19 integration (separate) |
| `docs/` | Detailed install/Traefik/Odoo/operations |
| `scripts/` | `bootstrap-*.sh`, `verify.sh`, `status.sh` |
| `InstallingJenkinsCommand.md` | Command reference (this deployment) |

## Quick test (standalone)

```bash
cd /opt/jenkins
cp .env.example .env
chmod 600 .env
docker compose config
docker compose up -d
bash scripts/verify.sh
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Open `http://<server-ip>:8080` (or `JENKINS_HTTP_PORT`).

## Traefik / HTTPS

Prerequisites: Traefik running, DNS for `jenkins.devops-odoo.com`, external network `proxy`, ACME resolver matches (`le` in this workspace).

```bash
cp .env.example .env
# set JENKINS_DOMAIN, CERTSRESOLVER=le, DOCKER_PROXY_NETWORK=proxy
docker network create proxy || true
docker compose -f docker-compose.traefik.yml config
docker compose -f docker-compose.traefik.yml up -d
```

After login set **Manage Jenkins → System → Jenkins URL** to `https://jenkins.devops-odoo.com/`.

## Odoo 17/19 integration

See [`IntegrationOdoo/README.md`](IntegrationOdoo/README.md) and [`docs/ODOO_INTEGRATION.md`](docs/ODOO_INTEGRATION.md).

| Instance | URL |
|---|---|
| Odoo 17 | `https://odoo17.devops-odoo.com` |
| Odoo 19 | `https://odoo19.devops-odoo.com` |

## Security

- Do not commit `.env`, credentials, tokens, or `jenkins_home` data.
- `/var/run/docker.sock` is mounted for Docker-based CI jobs — trusted environments only; restrict Jenkins admin/pipeline permissions.
- In Traefik mode, do not expose Jenkins UI port publicly; use firewall rules and HTTPS.

## Docs

- [docs/INSTALL.md](docs/INSTALL.md)
- [docs/TRAEFIK.md](docs/TRAEFIK.md)
- [docs/ODOO_INTEGRATION.md](docs/ODOO_INTEGRATION.md)
- [docs/OPERATIONS.md](docs/OPERATIONS.md)
- [InstallingJenkinsCommand.md](InstallingJenkinsCommand.md)
