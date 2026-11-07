# Jenkins ↔ Odoo 17 / 19 integration (separate module)

Integration is intentionally **separate** from the base Jenkins install (`IntegrationOdoo/`). It provides patterns for CI jobs/pipelines that interact with Odoo instances exposed behind Traefik.

## Target Odoo endpoints (examples)

| Instance | URL |
|---|---|
| Odoo 17 | `https://odoo17.devops-odoo.com` |
| Odoo 19 | `https://odoo19.devops-odoo.com` |

## Integration options

1. **Repository/Addon CI:** Jenkins checks out addon repos, runs lint/tests (Python, Odoo test framework) in a controlled runner image; deploys via git pull/rsync to addon mounts or via a dedicated deployment job.
2. **Webhook triggers:** Configure SCM webhooks (GitHub/GitLab) to trigger Jenkins pipelines per branch/tag.
3. **Odoo operations (careful):** Restart/update modules only through approved jobs; use Jenkins Credentials for API keys/SSH keys; never hardcode secrets.
4. **Network:** If Jenkins must reach Odoo by internal Docker name, attach to the appropriate network; if reaching via public HTTPS domains, ensure TLS trust and firewall rules.

## Required inputs (do not guess)

Provide these before creating production pipelines:
- Odoo addon repository URL(s) and branch strategy
- Target environment (staging/production) and domain mapping
- How addons are deployed (bind mount path, image rebuild, Odoo.sh-like flow, etc.)
- Credentials method (SSH key, token, Odoo API key) stored in Jenkins Credentials

## Files

- `IntegrationOdoo/README.md` — overview and checklist
- `IntegrationOdoo/pipelines/Jenkinsfile.odoo-addon.example` — example pipeline skeleton
- `IntegrationOdoo/odoo17/.env.integration.example` / `odoo19/` — placeholders for non-secret integration vars
