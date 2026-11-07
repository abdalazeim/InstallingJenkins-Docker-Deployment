# InstallingJenkins-Docker-Deployment — Jenkins on Docker (Phased, Organized, Legacy Preserved)

This repository provides a **clear, phased** way to deploy Jenkins with Docker on Ubuntu, plus preserved legacy/reference material. The work is organized so that **installation is verified first**, integrations are added **one by one only after install passes**, and CI/CD pipelines come **only after integrations pass**.

**Nothing old was deleted.** Previous scripts, compose files, docs, and integration assets are preserved under `InstallingJenkins/legacy/`, `InstallingJenkins/scripts-archive/`, and (where present) original repo files — kept for reference.

## Start here (organized package)
Use the phased package: **[`InstallingJenkins/`](InstallingJenkins/)**  
- Main guide (all steps, `/opt/InstallingJenkins`, gates): [`InstallingJenkins/README.md`](InstallingJenkins/README.md)
- Phase 1 install (Docker Compose, scripts, runbook): [`InstallingJenkins/01-Installation/`](InstallingJenkins/01-Installation/)
- Phase 1 gate report (record **actual** evidence): [`InstallingJenkins/INSTALLATION_REPORT.md`](InstallingJenkins/INSTALLATION_REPORT.md)
- Phase 2 integrations (gated): [`InstallingJenkins/02-Integration/`](InstallingJenkins/02-Integration/)
- Phase 3 CI/CD (gated): [`InstallingJenkins/03-CICD/`](InstallingJenkins/03-CICD/)
- Official Jenkins Docker reference (English, clear): [`InstallingJenkins/docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md`](InstallingJenkins/docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md)

## Quick start — Phase 1 only (Ubuntu + Docker, `/opt`)
> Do not overwrite an existing target that contains data. Complete Phase 1 and record evidence before any integration.

```bash
# Copy/clone this repo (or the InstallingJenkins folder) to the target
sudo git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/InstallingJenkins-src
sudo cp -a /opt/InstallingJenkins-src/InstallingJenkins /opt/InstallingJenkins
# or: sudo bash /path/to/InstallingJenkins/01-Installation/scripts/deploy-to-opt.sh /opt/InstallingJenkins

cd /opt/InstallingJenkins/01-Installation
chmod +x scripts/*.sh
cp .env.example .env && chmod 600 .env          # NEVER commit .env
bash scripts/preflight.sh                        # review existing Jenkins/ports — NO deletions
docker compose config && docker compose up -d
sleep 20 && docker compose ps
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword  # first run only
# Complete Setup Wizard (trusted network/VPN), create admin — no Phase 2/3 integrations yet
bash scripts/verify.sh                           # writes verify-output.txt (restart + jenkins_home persistence)
# Fill actual evidence in /opt/InstallingJenkins/INSTALLATION_REPORT.md — PASS required before Phase 2
```

## Phased workflow (same idea throughout)
| Phase | Goal | Gate / rule |
|---|---|---|
| **1. Installation** | Stable Jenkins LTS in Docker (`jenkins_home` named volume, restart, healthcheck; no Traefik/GitHub/Odoo/Ansible/docker.sock) | Must PASS with actual evidence in `INSTALLATION_REPORT.md` before Phase 2 |
| **2. Integration** (sequential) | `github → docker (security review first) → ansible → traefik (https://jenkins.devops-odoo.com; no shared Traefik edits without review/approval) → odoo17 → odoo19` | One at a time; independent tests + `TEST_REPORT.md` per integration |
| **3. CI/CD** | Separate pipelines per project/env/Odoo version (17/19 isolated) | After Phase 2 PASS; **Manual Approval** before production; no auto production DB/module upgrade |

## Key rules
- Keep install and integration separate; all organized work under `InstallingJenkins/`.
- **Never delete** data, files, volumes, or old scripts. No secrets in Git (`.env` ignored).
- No shared Odoo/Traefik changes without review/approval. No automatic production deploy or DB/Odoo module upgrade without explicit approval + a verified, restorable backup.
- **Never claim an unexecuted test passed** — record real commands/output.

## Legacy / preserved material
- `InstallingJenkins/legacy/` and `InstallingJenkins/scripts-archive/` — preserved previous deployment scripts, compose examples, docs, IntegrationOdoo examples, and upstream reference (`jenkins.sh`, `jenkins-plugin-cli.sh`, `jenkins-support`; recoverable via `git show 5169a68:<path>` from repo history).
- Existing root-level files (if any) remain kept as part of preservation/organization context; use the phased `InstallingJenkins/` layout for new/organized execution.

## Official Jenkins Docker image (reference summary)
This project deploys the official image (default `jenkins/jenkins:lts-jdk21`). Core practices reflected in Phase 1: named volume for `/var/jenkins_home`, `8080` UI / `50000` inbound agents only when needed (restrict exposure), restart policy, health checks, initial password from `/var/jenkins_home/secrets/initialAdminPassword`, and volume-based backups.  
Full, clear reference: [`InstallingJenkins/docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md`](InstallingJenkins/docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md). Upstream: https://hub.docker.com/r/jenkins/jenkins · https://www.jenkins.io/doc/book/installing/docker/ · https://github.com/jenkinsci/docker

---
Repository: https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment