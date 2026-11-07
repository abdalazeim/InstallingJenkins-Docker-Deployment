# Odoo 19 Integration (Phase 2 — only after Phase 1 PASS)

## Prerequisites
- Phase 1 PASS and required upstream integrations completed and tested.
- **Staging/test** Odoo 19 environment available with a **restorable backup**. Credentials in Jenkins Credentials.
- Odoo 19 configs/databases/addons paths kept **separate** from Odoo 17.

## Pipeline steps (implement as reviewed Jenkinsfiles/jobs)
1. Checkout source (controlled branch/tag).
2. Validate Python/XML/manifests and module dependencies.
3. Run available automated tests.
4. Build/validate images if applicable.
5. Verify restorable backup before staging/production-impacting steps.
6. Deploy to staging; run post-deploy health checks.
7. **Manual approval** before any production action.
8. Production deploy only with explicit approval + restorable backup; health check + report.
9. **No automatic production DB/module upgrade.**

## Acceptance tests (record in `TEST_REPORT.md`)
- [ ] Staging pipeline completes successfully (evidence).
- [ ] Post-deploy health checks pass on staging.
- [ ] No production database or production Odoo config modified.
- [ ] Manual approval gate present before production.

## Safety
Separate from Odoo 17. No secrets in Git. Never auto-upgrade production DB/modules.