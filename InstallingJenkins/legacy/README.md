# Legacy / Archive — preserved old install scripts & files (organization only)

This folder preserves previous installation/deployment material for reference. **Nothing here was deleted during reorganization.** These assets are **not** the default Phase 1 path and **must not** be run in production without review.

## `../scripts-archive/` (sibling archive folder)
Direct copies of prior deployment scripts and compose/config examples (kept intact): `bootstrap-standalone.sh`, `bootstrap-traefik.sh`, `status.sh`, `verify.sh`, `.env.example`, `docker-compose.yml`, `docker-compose.traefik.yml`. Use only as reference; the active Phase 1 install is `../01-Installation/`.

## `previous-deployment/`
Snapshot of the earlier deployment-oriented repo contents (before the phased `InstallingJenkins/` layout): compose/docs, `IntegrationOdoo/` examples, Jenkins init hook placeholder, `README.md`, `InstallingJenkinsCommand.md`, and the prior implementation report. Preserved for traceability.

## `upstream-jenkins-docker-5169a68/`
Reference files extracted from commit `5169a68` (early upstream Jenkins Docker image build history): `jenkins.sh`, `jenkins-plugin-cli.sh`, `jenkins-support`.

The full upstream build/test tree associated with that history was removed from the working tree in later commits (see git history, e.g. `2e1bea6`) but remains recoverable from the original repository:
```bash
# from the original git repo
git show 5169a68:<path>
# or inspect the commit/tree without deleting current data
git log --oneline --name-status -1 5169a68
```

## Safety
- No `.env` secrets are stored here.
- Do not delete volumes/data or modify production/shared Odoo/Traefik config based on archived files without review and approval.