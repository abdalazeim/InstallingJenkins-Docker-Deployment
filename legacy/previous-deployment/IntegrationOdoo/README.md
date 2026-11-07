# Odoo 17/19 Integration (separate from base Jenkins install)

This folder contains **integration-only** assets for connecting Jenkins CI/CD to **Odoo 17** and **Odoo 19** behind Traefik.

| Target | URL |
|---|---|
| Odoo 17 | `https://odoo17.devops-odoo.com` |
| Odoo 19 | `https://odoo19.devops-odoo.com` |

Base Jenkins install remains in the repo root (`docker-compose.yml`, `docker-compose.traefik.yml`). **Do not store secrets here** — use Jenkins Credentials.

## What to configure in Jenkins (UI)

1. Install suggested plugins + Pipeline/Git plugins as needed.
2. Add credentials (SCM, SSH deploy keys, tokens) in **Manage Jenkins → Credentials**.
3. Create a Pipeline/Multibranch job pointing to your addon repository and use `IntegrationOdoo/pipelines/Jenkinsfile.odoo-addon.example` as a starting template (copy into the addon repo or reference a shared library).
4. Set webhooks from your SCM to trigger builds.

## Structure

| Path | Purpose |
|---|---|
| `odoo17/`, `odoo19/` | Non-secret integration env examples |
| `pipelines/Jenkinsfile.odoo-addon.example` | Pipeline skeleton with Odoo17/19 targets |

See [`../docs/ODOO_INTEGRATION.md`](../docs/ODOO_INTEGRATION.md).
