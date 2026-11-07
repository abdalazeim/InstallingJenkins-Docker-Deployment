# Installation (Ubuntu, recommended `/opt/jenkins`)

## 1) Prerequisites

- Docker Engine + Docker Compose v2 (`docker compose`)
- Git
- (Traefik mode) Traefik running, external network `proxy`, DNS for the Jenkins domain

## 2) Install under `/opt/jenkins`

```bash
sudo mkdir -p /opt/jenkins
sudo chown "$USER":"$USER" /opt/jenkins
git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/jenkins
cd /opt/jenkins
cp .env.example .env
chmod 600 .env
nano .env   # adjust ports, TZ, UID/GID, domain if using Traefik
```

## 3) Validate config (recommended)

```bash
cd /opt/jenkins
docker compose config
# Traefik mode:
docker compose -f docker-compose.traefik.yml config
```

## 4) Start (standalone HTTP, good for first test)

```bash
cd /opt/jenkins
docker compose up -d
docker compose ps
docker compose logs -f jenkins
```

Get initial admin password:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
Open `http://SERVER_IP:8080` (or your `JENKINS_HTTP_PORT`).

## 5) Start (Traefik / HTTPS)

```bash
cd /opt/jenkins
# .env: JENKINS_DOMAIN=jenkins.devops-odoo.com, CERTSRESOLVER=le, DOCKER_PROXY_NETWORK=proxy
docker network create proxy || true
docker compose -f docker-compose.traefik.yml up -d
```
Open `https://jenkins.devops-odoo.com`. In Jenkins, set **Jenkins URL** to the same HTTPS URL.

## 6) Verify

```bash
cd /opt/jenkins
bash scripts/verify.sh
```

## 7) Data

Jenkins state lives in the named volume `jenkins_home`. Back it up before upgrades (see `docs/OPERATIONS.md`).
