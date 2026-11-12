# InstallingJenkins-Docker-Deployment — Jenkins on Docker (Phased, Organized, Legacy Preserved)

This repository provides a **clear, phased** way to deploy Jenkins with Docker on Ubuntu, plus preserved legacy/reference material. The work is organized so that **installation is verified first**, integrations are added **one by one only after install passes**, and CI/CD pipelines come **only after integrations pass**.

**Nothing old was deleted.** Previous scripts, compose files, docs, and integration assets are preserved under `legacy/`, `scripts-archive/`, and (where present) original repo files — kept for reference.

## Start here (organized package)
Use the phased package at the repository root:  
- Main guide (all steps, `/opt/InstallingJenkins`, gates): [`README.md`](README.md)
- Phase 1 install (Docker Compose, scripts, runbook): [`01-Installation/`](01-Installation/)
- Phase 1 gate report (record **actual** evidence): [`INSTALLATION_REPORT.md`](INSTALLATION_REPORT.md)
- Phase 2 integrations (gated): [`02-Integration/`](02-Integration/)
- Phase 3 CI/CD (gated): [`03-CICD/`](03-CICD/)
- Official Jenkins Docker reference (English, clear): [`docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md`](docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md)

## Quick start — Phase 1 only (Ubuntu + Docker)

Run these commands **on the target server** (e.g. Ubuntu) inside the `01-Installation` folder:

```bash
# 1) Get the updated files (choose one)
# Option A: if the repo is already cloned on the server
cd /opt/Jenkins--Deployment/01-Installation
git pull origin main

# Option B: clone fresh and copy only the 01-Installation folder
sudo git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/InstallingJenkins-src
sudo cp -a /opt/InstallingJenkins-src/01-Installation /opt/Jenkins--Deployment/01-Installation

cd /opt/Jenkins--Deployment/01-Installation

# 2) Make scripts executable and configure
chmod +x scripts/*.sh
cp .env.example .env && chmod 600 .env   # NEVER commit .env

# 3) Preflight — review existing Jenkins/ports/networks, NO deletions
bash scripts/preflight.sh

# 4) Start Jenkins
docker compose config
docker compose up -d
sleep 20 && docker compose ps

# 5) First access — complete Setup Wizard via browser (trusted network/VPN), create admin
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword   # first run only

# 6) Verify — restart persistence + jenkins_home + logs (writes verify-output.txt)
bash scripts/verify.sh

# 7) Record actual evidence in INSTALLATION_REPORT.md — PASS required before Phase 2
```

## Phased workflow (same idea throughout)
| Phase | Goal | Gate / rule |
|---|---|---|
| **1. Installation** | Stable Jenkins LTS in Docker (`jenkins_home` named volume, restart, healthcheck; no Traefik/GitHub/Odoo/Ansible/docker.sock) | Must PASS with actual evidence in `INSTALLATION_REPORT.md` before Phase 2 |
| **2. Integration** (sequential) | `github → docker (security review first) → ansible → traefik (https://jenkins.devops-odoo.com; no shared Traefik edits without review/approval) → odoo17 → odoo19` | One at a time; independent tests + `TEST_REPORT.md` per integration |
| **3. CI/CD** | Separate pipelines per project/env/Odoo version (17/19 isolated) | After Phase 2 PASS; **Manual Approval** before production; no auto production DB/module upgrade |

## Key rules
- Keep install and integration separate; all organized work at the repository root (`01-Installation/`, `02-Integration/`, `03-CICD/`).
- **Never delete** data, files, volumes, or old scripts. No secrets in Git (`.env` ignored).
- No shared Odoo/Traefik changes without review/approval. No automatic production deploy or DB/Odoo module upgrade without explicit approval + a verified, restorable backup.
- **Never claim an unexecuted test passed** — record real commands/output.

## Legacy / preserved material
- `legacy/` and `scripts-archive/` — preserved previous deployment scripts, compose examples, docs, IntegrationOdoo examples, and upstream reference (`jenkins.sh`, `jenkins-plugin-cli.sh`, `jenkins-support`; recoverable via `git show 5169a68:<path>` from repo history).
- Existing root-level files (if any) remain kept as part of preservation/organization context; use the phased root-level layout for new/organized execution.

## Official Jenkins Docker image (reference summary)
This project deploys the official image (default `jenkins/jenkins:lts-jdk21`). Core practices reflected in Phase 1: named volume for `/var/jenkins_home`, `8080` UI / `50000` inbound agents only when needed (restrict exposure), restart policy, health checks, initial password from `/var/jenkins_home/secrets/initialAdminPassword`, and volume-based backups.  
Full, clear reference: [`docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md`](docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md). Upstream: https://hub.docker.com/r/jenkins/jenkins · https://www.jenkins.io/doc/book/installing/docker/ · https://github.com/jenkinsci/docker

---
Repository: https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment