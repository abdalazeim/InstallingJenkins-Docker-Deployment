# Odoo 17/19 Integration (separate from base Jenkins install)

This folder contains **integration-only** assets for connecting Jenkins CI/CD to **Odoo 17** and **Odoo 19** (typically behind Traefik at `https://odoo17.devops-odoo.com` and `https://odoo19.devops-odoo.com`).

Base Jenkins install remains in the repo root (`docker-compose*.yml`). Do **not** mix secrets here.

## Structure

| Path | Purpose |
|---|---|
| `odoo17/`, `odoo19/` | Non-secret integration env examples / notes per instance |
| `pipelines/` | Example `Jenkinsfile` templates (adapt to your addon repos) |

## Checklist before enabling pipelines

- [ ] Jenkins reachable (standalone or `https://jenkins.devops-odoo.com` via Traefik)
- [ ] Odoo 17/19 reachable and healthy
- [ ] SCM credentials and deploy credentials stored in Jenkins Credentials
- [ ] Staging target defined; production deploy requires approval
- [ ] Backup/rollback plan for Odoo filestore/DB and addons

See [`../docs/ODOO_INTEGRATION.md`](../docs/ODOO_INTEGRATION.md).
