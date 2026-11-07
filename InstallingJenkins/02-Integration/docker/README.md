# Docker Integration (Phase 2 — only after Phase 1 PASS)

## Prerequisites
- Phase 1 PASS recorded. Security review completed/approved **before** enabling Docker control from Jenkins.
- A non-production test context (sample repo or compose project).

## Security review (required first)
Mounting `/var/run/docker.sock` grants effective host-level Docker control — high risk in shared/production CI. **Do not enable unrestricted socket access without review and isolation.** Prefer, where feasible:
- A dedicated, isolated build agent with minimal privileges.
- A protected remote Docker API (TLS/auth, network-restricted), least privilege.
- Clearly scoped jobs/credentials and audited access.

Document the chosen approach and approvals in `TEST_REPORT.md`.

## Steps
1. **Decide & approve** the execution model (socket vs isolated agent vs remote API) and document it.
2. **Implement minimally:** add only the files/config needed (compose override/env example/scripts/pipeline snippet) under this folder or the approved target path.
3. **Validate safely:** run `docker compose config` / a non-destructive build or lint task against a test project.
4. **Harden:** no public Docker API exposure; restrict credentials; safe image-prune policy only when explicitly approved.

## Acceptance tests (record in `TEST_REPORT.md`)
- [ ] Security approach documented and approved for the environment.
- [ ] Non-destructive Docker build or `docker compose config` validation succeeds (evidence).
- [ ] No unintended exposure of Docker API/ports; no production impact.

## Safety
No secrets in Git. No deletion of production images/containers/volumes. Preserve existing data.