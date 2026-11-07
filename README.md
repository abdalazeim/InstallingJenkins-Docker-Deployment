# Jenkins · Docker Deployment (LTS JDK 21) with Traefik & Odoo 17/19 Integration

[![Jenkins](https://img.shields.io/badge/Jenkins-LTS_JDK21-D24939?logo=jenkins&logoColor=white)](https://www.jenkins.io/)
[![Docker Compose](https://img.shields.io/badge/Docker-Compose_v2-2496ED?logo=docker&logoColor=white)](https://docs.docker.com/compose/)
[![Traefik](https://img.shields.io/badge/Traefik-Optional_HTTPS-24A1C1?logo=traefikproxy&logoColor=white)](https://doc.traefik.io/traefik/)
[![Odoo](https://img.shields.io/badge/Odoo-17%20%7C%2019_Integration-714B67?logo=odoo&logoColor=white)](https://www.odoo.com/)

**Repository:** https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment  
**Image:** [`jenkins/jenkins:lts-jdk21`](https://hub.docker.com/r/jenkins/jenkins) (official Jenkins Docker image)

This repository is a **ready-to-deploy Jenkins setup** (Docker Compose) plus a **separate Odoo 17/19 CI integration module**. It includes standalone HTTP mode for testing, Traefik HTTPS/domain mode for production-style access, persistent `jenkins_home` storage, and operational documentation.

> **Important:** This repo was reorganized as a *deployment* project (not the upstream Jenkins Docker image build source). Jenkins upstream image documentation/reference sections are included below for completeness.

---

## Table of Contents

1. [Deployment Overview](#deployment-overview)
2. [Requirements](#requirements)
3. [Install on Ubuntu (`/opt/jenkins`)](#install-on-ubuntu-optjenkins)
4. [Quick Start — Standalone (HTTP)](#quick-start--standalone-http)
5. [Quick Start — Traefik (HTTPS domain)](#quick-start--traefik-https-domain)
6. [Odoo 17/19 Integration (Separate Folder)](#odoo-1719-integration-separate-folder)
7. [Configuration (`.env`)](#configuration-env)
8. [Operations, Backup & Upgrade](#operations-backup--upgrade)
9. [Security](#security)
10. [Troubleshooting](#troubleshooting)
11. [Project Layout](#project-layout)
12. [Official Jenkins Docker Reference](#official-jenkins-docker-reference) (usage, agents, JVM, logging, reverse proxy, DNS, plugins, compose, upgrades, etc.)
13. [References](#references)

---

## Deployment Overview

| Mode | Compose file | Access | Notes |
|---|---|---|---|
| **Standalone** | `docker-compose.yml` | `http://<host>:8080` (default) | Best for first test; agent port `50000` configurable; UI published |
| **Traefik** | `docker-compose.traefik.yml` | `https://<JENKINS_DOMAIN>` | No public Jenkins UI host port; Traefik routes TLS; requires `proxy` network + DNS + resolver (default `le`) |

Persistent data: named volume **`jenkins_home`** (`/var/jenkins_home`).  
Odoo CI integration: **`IntegrationOdoo/`** (kept separate).

## Requirements

- Linux host (Ubuntu 22.04/24.04 recommended) with Docker Engine and Docker Compose v2 (`docker compose`).
- Git (for clone).
- **Traefik mode:** Traefik running, external Docker network `proxy` (or configured name), DNS for `JENKINS_DOMAIN`, valid ACME resolver name (`CERTSRESOLVER=le` matches this workspace’s Traefik pattern).

```bash
docker --version
docker compose version
```

## Install on Ubuntu (`/opt/jenkins`)

```bash
sudo mkdir -p /opt/jenkins
sudo chown "$USER":"$USER" /opt/jenkins
git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/jenkins
cd /opt/jenkins
cp .env.example .env
chmod 600 .env
nano .env
```

Validate (recommended before first run):

```bash
docker compose config
docker compose -f docker-compose.traefik.yml config
```

## Quick Start — Standalone (HTTP)

```bash
cd /opt/jenkins
docker compose up -d
docker compose ps
docker compose logs -f --tail=100 jenkins
bash scripts/verify.sh
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Open `http://<server-ip>:8080` (or `JENKINS_HTTP_PORT`) and complete the setup wizard: https://www.jenkins.io/doc/book/installing/docker/#setup-wizard

## Quick Start — Traefik (HTTPS domain)

1. Ensure Traefik is healthy and DNS points `JENKINS_DOMAIN` to the Traefik host.
2. Set in `.env` (example):
   ```env
   JENKINS_DOMAIN=jenkins.devops-odoo.com
   DOCKER_PROXY_NETWORK=proxy
   TRAEFIK_ENTRYPOINT=websecure
   CERTSRESOLVER=le
   ```
3. Start:
   ```bash
   docker network create proxy || true
   docker compose -f docker-compose.traefik.yml up -d
   docker compose -f docker-compose.traefik.yml ps
   bash scripts/verify.sh
   ```
4. In Jenkins: **Manage Jenkins → System → Jenkins URL** = `https://<JENKINS_DOMAIN>/`.

> The Traefik compose does **not** publish Jenkins port `8080` to the host; access is via Traefik only.

## Odoo 17/19 Integration (Separate Folder)

Integration assets are in **[`IntegrationOdoo/`](IntegrationOdoo/)** to keep base deployment independent.

| Target | Example URL |
|---|---|
| Odoo 17 | `https://odoo17.devops-odoo.com` |
| Odoo 19 | `https://odoo19.devops-odoo.com` |

**What to do:**
1. Jenkins and Odoo (17/19) reachable (HTTPS via Traefik as applicable).
2. Store SCM/SSH/deploy tokens in **Jenkins Credentials** (never commit secrets).
3. Adapt [`IntegrationOdoo/pipelines/Jenkinsfile.odoo-addon.example`](IntegrationOdoo/pipelines/Jenkinsfile.odoo-addon.example) in your addon repo or via shared library.
4. Review non-secret examples: `IntegrationOdoo/odoo17/.env.integration.example`, `IntegrationOdoo/odoo19/.env.integration.example`.

Details: [`docs/ODOO_INTEGRATION.md`](docs/ODOO_INTEGRATION.md), [`IntegrationOdoo/README.md`](IntegrationOdoo/README.md).

## Configuration (`.env`)

Copy `.env.example` → `.env` (`chmod 600`). Key variables:

| Variable | Default | Description |
|---|---|---|
| `JENKINS_IMAGE` | `jenkins/jenkins:lts-jdk21` | Jenkins image |
| `JENKINS_CONTAINER_NAME` | `jenkins` | Container name |
| `JENKINS_HTTP_PORT` | `8080` | Standalone UI port |
| `JENKINS_AGENT_PORT` | `50000` | Inbound agent port (restrict in production) |
| `JENKINS_UID` / `JENKINS_GID` | `1000` / `1000` | Runtime user mapping |
| `JENKINS_TZ` | `UTC` | Timezone |
| `JENKINS_DOMAIN` | `jenkins.devops-odoo.com` | Traefik host |
| `DOCKER_PROXY_NETWORK` | `proxy` | External Traefik network |
| `TRAEFIK_ENTRYPOINT` | `websecure` | Traefik entrypoint |
| `CERTSRESOLVER` | `le` | Traefik ACME resolver |

> **Docker socket:** Compose mounts `/var/run/docker.sock` to allow Docker-based CI jobs. This is **high privilege** — use only in trusted environments and restrict Jenkins permissions.

## Operations, Backup & Upgrade

Run from `/opt/jenkins`:

| Action | Standalone | Traefik |
|---|---|---|
| Validate | `docker compose config` | `docker compose -f docker-compose.traefik.yml config` |
| Start | `docker compose up -d` | `docker compose -f docker-compose.traefik.yml up -d` |
| Status | `docker compose ps` | `docker compose -f docker-compose.traefik.yml ps` |
| Logs | `docker compose logs -f jenkins` | `docker compose -f docker-compose.traefik.yml logs -f jenkins` |
| Stop (keep data) | `docker compose down` | `docker compose -f docker-compose.traefik.yml down` |
| Update image | `docker compose pull && docker compose up -d` | `docker compose -f docker-compose.traefik.yml pull && ... up -d` |

**Backup `jenkins_home` (example):**
```bash
docker run --rm -v jenkins_home:/data -v "$(pwd)":/backup alpine \
  tar czf /backup/jenkins_home_$(date +%F).tgz -C /data .
```
Restore to an empty volume with Jenkins stopped; test restores periodically.

More: [`docs/OPERATIONS.md`](docs/OPERATIONS.md). Command reference: [`InstallingJenkinsCommand.md`](InstallingJenkinsCommand.md).

## Security

- Never commit `.env`, passwords, tokens, or `jenkins_home` backups.
- Protect Jenkins with strong authentication, least-privilege authorization, and HTTPS (Traefik mode).
- Restrict inbound agent port `50000` (firewall/VPN/private network); prefer WebSocket agents where suitable.
- Treat `/var/run/docker.sock` as root-equivalent access on the host for Jenkins jobs — trusted CI only.
- In Traefik mode, keep Jenkins UI off direct public host ports; expose only 80/443 via Traefik as appropriate.

## Troubleshooting

| Symptom | Checks |
|---|---|
| UI not reachable (standalone) | `docker compose ps`, firewall/port mapping, `docker compose logs jenkins` |
| 404/Bad gateway (Traefik) | `proxy` network, labels, DNS, `CERTSRESOLVER`, Traefik logs |
| “Reverse proxy” warning | Set Jenkins URL to `https://<domain>/` |
| `jenkins_home` permission issues | Align `JENKINS_UID/GID` with host/volume expectations |
| Pipeline Docker commands fail | Socket mount intended? Host Docker accessible? Job permissions restricted? |

## Project Layout

```text
.
├── docker-compose.yml
├── docker-compose.traefik.yml
├── .env.example
├── README.md
├── InstallingJenkinsCommand.md
├── IMPLEMENTATION_REPORT.md
├── LICENSE.txt
├── docs/
│   ├── INSTALL.md
│   ├── TRAEFIK.md
│   ├── ODOO_INTEGRATION.md
│   └── OPERATIONS.md
├── IntegrationOdoo/                 # separate Odoo 17/19 CI integration
│   ├── README.md
│   ├── odoo17/.env.integration.example
│   ├── odoo19/.env.integration.example
│   └── pipelines/Jenkinsfile.odoo-addon.example
├── jenkins/init.groovy.d/
└── scripts/
    ├── bootstrap-standalone.sh
    ├── bootstrap-traefik.sh
    ├── status.sh
    └── verify.sh
```

---

## Official Jenkins Docker Reference

The following sections summarize/reference common usage from the official Jenkins Docker image documentation (adapted). For the latest upstream details, see https://github.com/jenkinsci/docker and https://hub.docker.com/r/jenkins/jenkins.

### Basic `docker run` usage

```bash
docker run -p 8080:8080 -p 50000:50000 --restart=on-failure jenkins/jenkins:lts-jdk21
```

With a named volume (recommended):

```bash
docker run -p 8080:8080 -p 50000:50000 --restart=on-failure -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk21
```

All Jenkins data lives in `/var/jenkins_home` (plugins, configuration, jobs metadata, etc.). Prefer **named volumes** over bind mounts to avoid host permission issues. If you must bind mount, ensure the host directory is accessible to UID 1000 (default Jenkins user) or use an appropriate `-u`/user mapping.

Initial admin password:
```bash
docker exec <container> cat /var/jenkins_home/secrets/initialAdminPassword
```

### Connecting agents

- **Inbound TCP agents:** map `-p 50000:50000` (restrict exposure in production).
- **SSH/outbound agents or WebSocket agents:** inbound TCP agent port may not be required depending on setup.
- Jenkins project recommends not running builds on the built-in/controller node for production security/performance.

### Passing JVM parameters

Use `JAVA_OPTS` / `JENKINS_JAVA_OPTS` for controller JVM/system properties (e.g., heap, proxy, system properties). Prefer `JENKINS_JAVA_OPTS` for Jenkins-controller-specific options.

### Logging configuration

You can configure `java.util.logging` via a properties file and mount it into the container, passing `-Djava.util.logging.config.file=...` through `JAVA_OPTS`/`JENKINS_JAVA_OPTS`. See Jenkins logging docs and upstream image README for examples.

### Reverse proxy

When Jenkins runs behind a reverse proxy (Nginx/Apache/Traefik), configure the proxy correctly and set the Jenkins URL. With a path prefix, you may need `JENKINS_OPTS="--prefix=/jenkins"` and matching proxy rules.
- https://www.jenkins.io/doc/book/system-administration/reverse-proxy-configuration-with-jenkins/
- https://www.jenkins.io/doc/book/system-administration/reverse-proxy-configuration-nginx/
- https://www.jenkins.io/doc/book/system-administration/reverse-proxy-configuration-apache/

### DNS configuration

If startup shows “Jenkins instance appears to be offline” with `UnknownHostException` (e.g., `updates.jenkins.io`), configure container DNS:
```bash
docker run --dns 1.1.1.1 --dns 8.8.8.8 ...
```
In Compose, add `dns:` under the service as needed.

### Jenkins launcher parameters

Arguments passed to the image can be forwarded to the Jenkins launcher; `JENKINS_OPTS` is useful in derived images. `JENKINS_SLAVE_AGENT_PORT` can influence the agent port (see upstream notes about precedence with `JAVA_OPTS`/`JENKINS_JAVA_OPTS`).

### Customizing the image (tools, init scripts, plugins)

For additional OS packages or baked-in configuration, build a derived image from `jenkins/jenkins:lts-jdk21`. Use `/usr/share/jenkins/ref` to seed `JENKINS_HOME` on first initialization (files are copied if missing; `.override` can force replacement — use carefully). Example init Groovy/plugins patterns are in the upstream repo: https://github.com/jenkinsci/docker

**Plugin installation:** use `jenkins-plugin-cli` with a plugins list/file. Pin versions for reproducibility; keep plugins updated for security. Upstream plugin management details: https://github.com/jenkinsci/plugin-installation-manager-tool/

**Casc:** Jenkins Configuration as Code (JCasC) is often the best approach for dynamic/reproducible controller config: https://www.jenkins.io/projects/jcasc/

### Docker Compose (general example)

```yaml
services:
  jenkins:
    image: jenkins/jenkins:lts-jdk21
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home
volumes:
  jenkins_home:
```

This repository’s production-oriented Compose files are `docker-compose.yml` and `docker-compose.traefik.yml` at the repo root.

### Upgrading

1. Back up `jenkins_home`.
2. Pull the new image / update `JENKINS_IMAGE`.
3. Recreate the container (`docker compose up -d`).
4. Verify plugins, jobs, credentials, agents, and integrations.

Plugin upgrade behavior in the official image can be influenced by environment flags (e.g., `PLUGINS_FORCE_UPGRADE`, `TRY_UPGRADE_IF_NO_MARKER`) — consult upstream docs before relying on them.

---

## References

- **This deployment repo:** https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment
- **Command reference (AR/EN):** [`InstallingJenkinsCommand.md`](InstallingJenkinsCommand.md)
- **Jenkins docs:** https://www.jenkins.io/doc/
- **Official Jenkins Docker image:** https://hub.docker.com/r/jenkins/jenkins
- **Upstream docker image repo:** https://github.com/jenkinsci/docker
- **Plugin Installation Manager:** https://github.com/jenkinsci/plugin-installation-manager-tool
- **JCasC:** https://www.jenkins.io/projects/jcasc/
- **Docker volumes:** https://docs.docker.com/storage/volumes/
- **Traefik:** https://doc.traefik.io/traefik/

## License

`LICENSE.txt` applies to this repository’s content where noted. Jenkins and the official Jenkins Docker image are licensed under their respective upstream licenses. Review upstream terms when redistributing images/configurations.
