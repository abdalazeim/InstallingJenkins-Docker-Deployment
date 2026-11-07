# Legacy: Odoo 17/19 integration examples (archived)

Archived, **non-secret** integration examples preserved from the previous deployment layout. They are reference material only.

| Example target | URL (reference) |
|---|---|
| Odoo 17 | `https://odoo17.devops-odoo.com` |
| Odoo 19 | `https://odoo19.devops-odoo.com` |

## Current location of active work
- Phased integration plans/tests: `../../../02-Integration/odoo17/` and `../../../02-Integration/odoo19/` (execute only after Phase 1 PASS; record results in each `TEST_REPORT.md`).
- Do **not** store secrets here or in Git. Use Jenkins Credentials.
- No production DB/module upgrades without explicit approval + a verified, restorable backup.