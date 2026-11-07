# Ansible Integration (Phase 2 — only after Phase 1 PASS)

## Prerequisites
- Phase 1 PASS recorded. Prior integrations required by your plan (e.g., GitHub/Docker) completed if dependencies exist.
- A staging/test inventory or `--check`-safe target. SSH keys stored in Jenkins Credentials (no keys in Git).

## Steps
1. **Credentials:** Add Ansible/SSH credentials in Jenkins Credentials; record IDs/types only.
2. **Playbooks/roles:** Keep Ansible content in its approved repo/path. Jenkins should **run** playbooks (not reimplement them in Groovy/shell logic unnecessarily).
3. **Job/pipeline:** Create a Jenkins job/stage that runs a safe playbook (`--check`, staging inventory, or read-only health check) first.
4. **Broader tasks (when approved):** server prereqs, service config, Odoo staging deploy, restarts/health checks, backup steps — each tested and recorded.
5. **Record evidence** in `TEST_REPORT.md`.

## Acceptance tests (record in `TEST_REPORT.md`)
- [ ] Credentials configured (IDs/types only).
- [ ] Safe/non-destructive Ansible run succeeds (`--check` or staging) with output captured.
- [ ] No unintended changes to production; no secrets in logs/artifacts committed to Git.

## Safety
No production changes without explicit approval + restorable backup. Preserve existing data/config.