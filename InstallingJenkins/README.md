# InstallingJenkins — Phased Jenkins (Docker) Deployment

This directory is the **organized, phase-based** package for running Jenkins on Ubuntu with Docker. It separates **installation** (Phase 1) from **integrations** (Phase 2) and **CI/CD pipelines** (Phase 3) so every step can be verified independently.

**Nothing old was deleted.** Previous install scripts, compose files, docs, and integration assets are preserved under `legacy/` and `scripts-archive/` for reference. This is an organizational refactor, not a destructive replacement.

## Ideas incorporated (from official Jenkins Docker guidance)
- Run the official LTS image (`jenkins/jenkins:lts-jdk21` by default) with a **named volume** for `/var/jenkins_home` (plugins/config/jobs live there). Avoid host bind mounts unless you manage UID/GID permissions carefully.
- Map **8080** for the UI (standalone test) and **50000** only when you need inbound TCP agents; do not expose 50000 publicly. SSH/websocket agents may not need 50000.
- Use `--restart unless-stopped`/compose `restart: unless-stopped` and a health check.
- Retrieve the first-run admin password from `/var/jenkins_home/secrets/initialAdminPassword`.
- Back up by snapshotting/backing up the `jenkins_home` volume (treat it like a database). DNS issues can show “Jenkins appears to be offline” on first boot; check container logs/DNS.

## Repository layout context
This `InstallingJenkins/` folder may be part of a larger repository (e.g. `InstallingJenkins-Docker-Deployment`). Adjust clone/copy paths to where this folder lives. Legacy deployment files may still exist at the repo root; they are kept. The supported, organized workflow is the phased layout here.

## Target host install path
Recommended on Ubuntu: **`/opt/InstallingJenkins`**.

## All steps — Phase 1 (install only, no integrations)

> **Gate:** Do not start Phase 2 until Phase 1 passes and `INSTALLATION_REPORT.md` is updated with actual evidence.

### Step 1 — Prepare the target (Ubuntu)
```bash
# Verify OS/Docker/ports/networks/existing Jenkins data (NO deletions)
# Copy/clone InstallingJenkins to /opt first (Step 2), then run:
cd /opt/InstallingJenkins/01-Installation
chmod +x scripts/*.sh
bash scripts/preflight.sh
```
Review output carefully. If an existing Jenkins container/volume exists, **preserve data** and do not overwrite.

### Step 2 — Place files under `/opt`
```bash
# Option A: clone/copy the folder that contains InstallingJenkins
sudo git clone <REPO_URL> /opt/InstallingJenkins-src
sudo cp -a /opt/InstallingJenkins-src/InstallingJenkins /opt/InstallingJenkins

# Option B: helper (refuses to overwrite an existing target)
sudo bash /path/to/InstallingJenkins/01-Installation/scripts/deploy-to-opt.sh /opt/InstallingJenkins
```

### Step 3 — Configure environment (no secrets in Git)
```bash
cd /opt/InstallingJenkins/01-Installation
cp .env.example .env
chmod 600 .env
# Edit .env if needed: JENKINS_IMAGE, container name, ports, UID/GID, TZ.
# Keep JENKINS_AGENT_PORT off the public internet (firewall / do not expose).
```

### Step 4 — Validate Compose and start Jenkins
```bash
docker compose config          # must succeed
docker compose up -d
sleep 20
docker compose ps
docker inspect --format 'status={{.State.Status}} health={{if .State.Health}}{{.State.Health.Status}}{{else}}n/a{{end}}' jenkins
```

### Step 5 — First access and secure setup
```bash
# UI health (container-local) and first-run password
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword  # first run only
```
- Open `http://<ubuntu-host>:8080` from a trusted network/VPN (adjust port if you changed `JENKINS_HTTP_PORT`).
- Complete the Setup Wizard, create an admin user, and apply initial security.
- **Do not** install/configure GitHub, Docker pipeline, Ansible, Traefik, or Odoo integrations in Phase 1. Install only minimal required plugins for basic operation if needed.

### Step 6 — Verify persistence, storage, and logs (actual tests)
```bash
# Automated evidence capture (includes restart + jenkins_home marker test)
bash scripts/verify.sh          # writes 01-Installation/verify-output.txt

# Manual checks (record output in INSTALLATION_REPORT.md)
docker compose restart && sleep 20 && docker compose ps
docker volume inspect jenkins_home
docker compose logs --tail=120 jenkins
```
Confirm: UI still reachable, data persisted after restart, no critical errors, `jenkins_home` volume intact, agent port 50000 not publicly exposed.

### Step 7 — Update the Phase 1 gate report
Edit `/opt/InstallingJenkins/INSTALLATION_REPORT.md` and fill **actual commands/output/evidence** for every acceptance item. Mark PASS only when all required checks succeed. If any critical check fails: fix, re-test, **stop** (no Phase 2).

### Phase 1 acceptance (all required)
- [ ] Jenkins running/healthy.
- [ ] UI reachable.
- [ ] Data persists after restart (`jenkins_home`).
- [ ] Storage/volume integrity confirmed; no data/volumes deleted.
- [ ] No critical runtime errors.
- [ ] Initial access secured (admin; 50000 restricted).

## Phase 2 — Integrations (only after Phase 1 PASS)
Run sequentially; do not start the next until the current integration is tested and recorded in its `TEST_REPORT.md`:
1. `02-Integration/github/` — GitHub (credentials/webhooks; no tokens in Git).
2. `02-Integration/docker/` — Docker CI (**security review first**; avoid unrestricted docker.sock).
3. `02-Integration/ansible/` — Ansible playbooks triggered by Jenkins (safe/staging test first).
4. `02-Integration/traefik/` — `https://jenkins.devops-odoo.com` (proxy network/resolver alignment; **no shared Traefik changes without review/approval**).
5. `02-Integration/odoo17/` and `02-Integration/odoo19/` — separate configs/DBs; staging first; **no production DB/module upgrade without explicit approval + restorable backup**.

See `02-Integration/README.md`.

## Phase 3 — CI/CD pipelines (only after Phase 2)
Separate pipelines per project/environment/Odoo version (17/19): Checkout → Validation → Static Analysis → Dependency Validation → Automated Tests → Docker Build → Image Validation → Backup Verification → Staging Deploy → Post-Deploy Tests → **Manual Approval** → Production Deploy → Health Check → Deployment Report.  
No automatic production deploy or DB/module upgrade. See `03-CICD/README.md`.

## Folder map
| Path | Purpose | Status |
|---|---|---|
| `01-Installation/` | Compose + env example + scripts + docs (Phase 1 only) | Ready for target execution |
| `02-Integration/` | Per-integration folders + `TEST_REPORT.md` templates | NOT RUN (gated) |
| `03-CICD/` | Pipeline plan | NOT RUN (gated) |
| `legacy/` | Preserved previous/upstream reference material | Archived |
| `scripts-archive/` | Preserved old bootstrap/compose/verify scripts | Archived |
| `INSTALLATION_REPORT.md` | Phase 1 gate report (evidence required) | Not approved until PASS |

## Rules
- Keep all work under `InstallingJenkins/`. Keep install/integration separate.
- Never delete data, files, volumes, or old scripts. Never replace existing Jenkins data without review.
- No secrets in Git. No shared Odoo/Traefik edits without review/approval. No automatic production/DB upgrades.
- Record real commands/output; never claim an unexecuted test passed.