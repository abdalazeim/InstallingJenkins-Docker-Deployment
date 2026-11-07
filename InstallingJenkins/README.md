# InstallingJenkins — Phased Jenkins (Docker) Deployment

This directory is the **organized, phase-based** package for running Jenkins on Ubuntu with Docker. It separates **installation** (Phase 1) from **integrations** (Phase 2) and **CI/CD pipelines** (Phase 3) so every step can be verified independently.

**Nothing old was deleted.** Previous install scripts, compose files, docs, and integration assets are preserved under `legacy/` and `scripts-archive/` (organization only).

## Ideas incorporated (from official Jenkins Docker guidance)
- Run the official LTS image (`jenkins/jenkins:lts-jdk21` default) with a **named volume** for `/var/jenkins_home` (plugins/config/jobs). Avoid bind mounts unless UID/GID permissions are managed.
- Map **8080** (UI) and **50000** only for inbound TCP agents; do not expose 50000 publicly. SSH/websocket agents may not need 50000.
- Use `restart: unless-stopped` and a health check. Read the first-run password from `/var/jenkins_home/secrets/initialAdminPassword`.
- Back up the `jenkins_home` volume (treat like a database). Check logs/DNS if first boot shows *“Jenkins appears to be offline.”*
- Full clear reference (English): [`docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md`](docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md).

## Target host
Recommended path on Ubuntu: **`/opt/InstallingJenkins`**. This folder may live inside a larger repo — adjust clone/copy paths accordingly.

## Phase 1 — Install only (no integrations)
> **Gate:** Do not start Phase 2 until all Phase 1 acceptance checks pass and `INSTALLATION_REPORT.md` contains **actual evidence**.

```bash
# 1) Place under /opt (no overwrite of existing target)
sudo bash /path/to/InstallingJenkins/01-Installation/scripts/deploy-to-opt.sh /opt/InstallingJenkins
# or copy/clone the folder to /opt/InstallingJenkins

# 2) Configure
cd /opt/InstallingJenkins/01-Installation
chmod +x scripts/*.sh
cp .env.example .env && chmod 600 .env   # NEVER commit .env

# 3) Preflight (review existing Jenkins/ports/networks — NO deletions)
bash scripts/preflight.sh

# 4) Start
docker compose config
docker compose up -d && sleep 20 && docker compose ps

# 5) First access (trusted network/VPN), complete Setup Wizard, create admin — no integrations/plugins for Phase 2/3 yet
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# 6) Verify (restart + jenkins_home persistence + logs) — writes verify-output.txt
bash scripts/verify.sh

# 7) Record evidence in /opt/InstallingJenkins/INSTALLATION_REPORT.md (PASS/FAIL per item)
```

**Phase 1 acceptance (all required):** Jenkins healthy, UI reachable, data persists after restart, `jenkins_home` volume intact/no deletions, no critical log errors, initial access secured (admin; 50000 not public).

## Phase 2 — Integrations (after Phase 1 PASS only)
Sequential, one at a time, each with independent tests + `TEST_REPORT.md`: `github → docker (security review first; avoid unrestricted docker.sock) → ansible → traefik (https://jenkins.devops-odoo.com; no shared Traefik edits without review/approval) → odoo17 → odoo19` (Odoo 17/19 separate configs/DBs; staging first; manual approval; **no auto production DB/module upgrade**). See [`02-Integration/README.md`](02-Integration/README.md).

## Phase 3 — CI/CD (after Phase 2 PASS)
Separate pipelines per project/env/Odoo version (17/19): Checkout→Validation→Static Analysis→Deps→Tests→Build→Image Validation→Backup Verification→Staging→Post-Deploy Tests→**Manual Approval**→Production→Health Check→Report. No automatic production/DB upgrades. See [`03-CICD/README.md`](03-CICD/README.md).

## Folder map
| Path | Purpose | Status |
|---|---|---|
| `01-Installation/` | Phase 1 Compose + `.env.example` + scripts + docs | Ready for target execution |
| `02-Integration/` | Per-integration plans + `TEST_REPORT.md` templates | NOT RUN (gated) |
| `03-CICD/` | Pipeline plan | NOT RUN (gated) |
| `docs/` | Official Jenkins Docker reference (English) | Reference |
| `legacy/` + `scripts-archive/` | **Preserved old scripts/files (not deleted)** | Archived |
| `INSTALLATION_REPORT.md` | Phase 1 gate evidence | Not approved until PASS |

## Rules
Keep all work under `InstallingJenkins/`. Never delete data/files/volumes/old scripts. No secrets in Git. No shared Odoo/Traefik edits without review/approval. No production/DB upgrades without explicit approval + restorable backup. Never claim an unexecuted test passed.