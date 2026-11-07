# Phase 2 — Integrations (sequential, after Phase 1 PASS only)

## Entry gate (mandatory)
Start Phase 2 **only** when every Phase 1 acceptance item is verified on the target and `../INSTALLATION_REPORT.md` is updated with **actual evidence** (PASS). If any item is incomplete/failing: **stop** — do not integrate.

## How to run Phase 2 (all integrations)
1. Confirm Phase 1 PASS in `../INSTALLATION_REPORT.md` and ensure Jenkins is stable/reachable.
2. Execute integrations **in order**. Do **not** start the next until the current integration has: prerequisites checked, independent files created, documentation written, independent tests executed, and results recorded (PASS/FAIL + evidence) in its `TEST_REPORT.md`.
3. Use Jenkins Credentials / secure stores for all secrets. **Never** commit tokens, passwords, keys, or `.env`.
4. Prefer safe/staging/non-destructive tests first. No production deploy or DB/module upgrade without explicit approval + a restorable backup.
5. Do not modify shared Odoo/Traefik configuration without review/approval; document any approved change.

## Execution order
| # | Folder | What to do (steps) | Tests to record | Safety |
|---|---|---|---|---|
| 1 | `github/` | Add SCM credentials in Jenkins; configure repo checkout/webhook or multibranch scan; create job/pipeline snippet pointing to a test repo. | Credential created (type only, no values), checkout succeeds, trigger/webhook/scan verified (if used). | No tokens in Git/Jenkinsfiles; protect webhooks. |
| 2 | `docker/` | Perform a **security review** (avoid unrestricted `/var/run/docker.sock`; prefer isolated build agent or protected remote Docker API, least privilege). Add compose validation/build pipeline in a controlled scope. | Security approach documented/approved; non-destructive build/compose validation passes. | No public Docker API; no host-wide socket exposure without review. |
| 3 | `ansible/` | Store SSH keys in Jenkins Credentials; create playbook-run job/stage; target staging or `--check` first (inventory, prereqs, health check, backup steps). | Safe/non-destructive playbook run succeeds with captured output. | No destructive prod changes without approval/backup. |
| 4 | `traefik/` | Route Jenkins via Traefik: `https://jenkins.devops-odoo.com`, Let’s Encrypt, HTTP→HTTPS, no direct public UI port, `proxy` network, correct headers/WebSocket if needed. Align with existing resolver/network (workspace pattern: resolver `le`, network `proxy`). | DNS resolves, HTTPS valid, UI reachable via domain, data persists after restart. | **No shared Traefik edits without review/approval**; document changes. |
| 5 | `odoo17/` | Build Odoo 17 pipeline: checkout, Python/XML lint, module/deps validation, tests, build/image (if used), staging deploy, post-deploy health; manual approval gate before production. | Staging pipeline passes (evidence in `TEST_REPORT.md`); no production DB impact. | Separate from Odoo 19 configs/DBs. **No production DB/module upgrade without explicit approval + restorable backup.** |
| 6 | `odoo19/` | Same as Odoo 17, isolated to Odoo 19. | Staging pipeline passes; no production DB impact. | Separate from Odoo 17. No automatic production DB/module upgrade. |

## Required artifacts per integration folder
- `README.md` — setup, prerequisites, decisions, and links to evidence (keep updated).
- `TEST_REPORT.md` — **actual** commands, output summaries, PASS/FAIL, date/host, and issues.
- Optional: `*.env.example` (no secrets), scripts, Compose overrides, pipeline snippets/Jenkinsfile templates.