# GitHub Integration (Phase 2 — only after Phase 1 PASS)

## Prerequisites
- Phase 1 PASS recorded in `../../INSTALLATION_REPORT.md`. Jenkins UI reachable and stable.
- A test GitHub repository/branch you control (do not test against production repos/data).
- Network access to GitHub and (if webhooks are used) a reachable Jenkins URL (Traefik/domain may come later; use what is verified).

## Steps
1. **Credentials (Jenkins UI):** Add GitHub/SCM credentials in *Manage Jenkins → Credentials* (token/SSH key/app credential as appropriate). Record credential **type/ID only** — never values.
2. **Plugins/access:** Use only stable, required plugins for Git/GitHub/Pipeline (defer non-essential integration plugins to their phases). Confirm compatibility with your Jenkins LTS.
3. **Job/pipeline:** Create a test Pipeline or Multibranch job that checks out the test repo/branch. Keep Jenkinsfile/pipeline logic in the repo or a reviewed script; no secrets inline.
4. **Trigger:** Configure webhook (with secret) or periodic/scan trigger as appropriate. Protect webhook endpoints; do not expose Jenkins unnecessarily.
5. **Document & test:** Save pipeline/job config notes (sanitized) and run an independent test. Update `TEST_REPORT.md` with actual results.

## Acceptance tests (record in `TEST_REPORT.md`)
- [ ] Credential exists (type/ID recorded; no secret values).
- [ ] Checkout of test repo/branch succeeds (build log evidence).
- [ ] Trigger/webhook/scan behaves as expected (if configured).
- [ ] No tokens/passwords stored in Git or Jenkinsfiles.

## Safety
No secrets in Git. No production repo changes during testing. Preserve existing Jenkins data.