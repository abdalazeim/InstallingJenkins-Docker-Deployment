# Installation (Ubuntu, recommended `/opt/jenkins`)

## 1) Prerequisites

- Docker Engine + Docker Compose v2 (`docker compose`)
- Git (if cloning)
- For Traefik mode: Traefik installed/running, external network `proxy`, DNS A/AAAA records

## 2) Install under `/opt/jenkins`

```bash
sudo mkdir -p /opt/jenkins
sudo chown "$USER":"$USER" /opt/jenkins
git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/jenkins
cd /opt/jenkins
cp .env.example .env
chmod 600 .env
# edit .env as needed
```

## 3) Start (standalone)

```bash
cd /opt/jenkins
docker compose up -d
docker compose ps
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

## 4) Start (Traefik / HTTPS)

```bash
cd /opt/jenkins
# .env: JENKINS_DOMAIN=jenkins.devops-odoo.com, CERTSRESOLVER=le, DOCKER_PROXY_NETWORK=proxy
docker network create proxy || true
docker compose -f docker-compose.traefik.yml up -d
```

## 5) Data persistence

Jenkins data is stored in the named volume `jenkins_home`. Back it up before upgrades.
See `docs/OPERATIONS.md`.
