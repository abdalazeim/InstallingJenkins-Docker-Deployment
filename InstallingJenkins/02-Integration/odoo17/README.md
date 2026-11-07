# Odoo 17 Integration (Phase 2 — only after Phase 1 PASS)

## Prerequisites
- Phase 1 PASS and required upstream integrations (GitHub/Docker/Ansible/Traefik as applicable) completed and tested.
- **Staging/test** Odoo 17 environment available with a **restorable backup**. Access/credentials stored in Jenkins Credentials.
- Odoo 17 configs/databases/addons paths kept **separate** from Odoo 19.

## Pipeline steps (implement as reviewed Jenkinsfiles/jobs)
1. **Checkout** Odoo/addons source (branch/tag controlled).
2. **Validate:** Python lint, XML/Odoo manifest/view checks, module/dependency validation.
3. **Test:** run available automated tests (non-destructive).
4. **Build/image (if used):** build/tag/validate images; no unsafe cleanup.
5. **Backup verification:** confirm a restorable backup exists **before** any staging/production-impacting step.
6. **Deploy to staging** (approved mechanism: Ansible/compose/SSH as designed) and run **post-deploy health checks**.
7. **Manual approval gate** before any production action.
8. **Production deploy (only with explicit approval + restorable backup):** controlled rollout, health check, deployment report.
9. **No automatic production DB/module upgrade.** Record results.

## Acceptance tests (record in `TEST_REPORT.md`)
- [ ] Staging pipeline completes successfully (evidence/log refs).
- [ ] Post-deploy health checks pass on staging.
- [ ] No production database or production Odoo config modified.
- [ ] Manual approval gate present before production.

## Safety
Separate from Odoo 19. No secrets in Git. Never auto-upgrade production DB/modules.