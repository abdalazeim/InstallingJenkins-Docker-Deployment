# Phase 3 — CI/CD Pipelines (only after all Phase 2 integrations PASS)

## Gate
Create and run Phase 3 pipelines **only** after every required Phase 2 integration is implemented, tested independently, and recorded as PASS in its `TEST_REPORT.md`. If any integration is incomplete: stop.

## Design rules
- **Separate pipelines** per project, environment, and Odoo version (**17 and 19 must not share configs or databases**).
- Keep Jenkinsfiles/pipeline logic in reviewed source control; use Jenkins Credentials for all secrets (no tokens/passwords/keys in Git).
- Support safe re-runs and clear deployment reports/log retention.

## Standard stages (adapt per project)
| Stage | Purpose | Notes |
|---|---|---|
| 1. Checkout | Fetch exact branch/tag/commit | Controlled refs; record commit SHA |
| 2. Code Validation | Basic correctness/lint entry | Python/XML/Odoo module structure as applicable |
| 3. Static Analysis | Deeper checks | Stable tools only; fail on defined thresholds |
| 4. Dependency Validation | Manifests/requirements/addon deps | No undeclared/unsafe deps |
| 5. Automated Tests | Unit/integration/Odoo tests available | Non-destructive; capture results |
| 6. Docker Build | Build images (if used) | Tag with traceable version/SHA |
| 7. Image Validation | Smoke/inspect/config checks | No deployment yet |
| 8. Backup Verification | Confirm **restorable** backup exists | Mandatory before staging/prod-impacting rollout paths as defined |
| 9. Deploy to Staging | Apply to staging only | Isolated from production; uses approved mechanism (Ansible/Compose/SSH) |
| 10. Post-Deployment Tests | Health checks/smoke on staging | Must pass before approval |
| 11. **Manual Approval** | Human gate | Required before any production action |
| 12. Deploy to Production | Controlled rollout | **Only** with explicit approval + restorable backup; no auto DB/module upgrade |
| 13. Health Check | Verify production service health | Rollback plan ready |
| 14. Deployment Report | Record who/what/when/result | Keep audit trail; no secrets |

## Mandatory safety controls
- **No automatic production deployment** or **no automatic production DB/Odoo module upgrade**.
- Production-impacting actions require **explicit approval** and a **verified, restorable backup**.
- No deletion of production data, containers, volumes, or files during deployment.
- Do not modify shared Odoo/Traefik settings without review/approval.

## Status
**NOT executed** until Phase 2 integrations pass and real pipeline tests are run and recorded.