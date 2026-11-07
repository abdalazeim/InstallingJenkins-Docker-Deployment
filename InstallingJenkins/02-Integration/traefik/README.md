# Traefik Integration (Phase 2 — only after Phase 1 PASS)

## Target
Expose Jenkins at **`https://jenkins.devops-odoo.com`** via Traefik: TLS (Let’s Encrypt), HTTP→HTTPS redirect, **no direct public exposure** of the Jenkins UI host port, Docker `proxy` network, and correct reverse-proxy headers/WebSocket support as needed.

## Prerequisites
- Phase 1 PASS. Traefik running and healthy. DNS for `jenkins.devops-odoo.com` points to the Traefik host.
- External Docker network and ACME resolver aligned with the active Traefik setup (workspace pattern: network `proxy`, resolver `le`) — **verify on the target**.

## Steps
1. **Review first:** Inspect the live Traefik config (entrypoints, `proxy` network, resolver name, redirect middleware). **Do not modify shared Traefik settings without review/approval.** Document any approved change.
2. **Prepare Jenkins for proxy mode:** Use the Traefik compose variant/configuration (no published UI port to the public; attach to `proxy`; set labels, router/service, TLS certresolver, and proxy headers/`JENKINS_OPTS` prefix if required by your path). Keep `jenkins_home` persistent.
3. **Apply:** `docker compose -f docker-compose.traefik.yml config && docker compose -f docker-compose.traefik.yml up -d` (from the approved path). Ensure the `proxy` network exists (`docker network create proxy || true` only if appropriate and non-conflicting).
4. **Set Jenkins URL:** In Jenkins system config set the external URL to `https://jenkins.devops-odoo.com/` and verify reverse-proxy behavior.
5. **Test & record:** DNS, HTTPS/certificate, UI access via domain, redirect, restart persistence. Update `TEST_REPORT.md`.

## Acceptance tests (record in `TEST_REPORT.md`)
- [ ] DNS resolves correctly.
- [ ] `https://jenkins.devops-odoo.com` serves valid TLS.
- [ ] UI reachable via domain; no direct public UI port exposure required.
- [ ] HTTP redirects to HTTPS (if configured).
- [ ] Jenkins data persists after restart.

## Safety
No secrets in Git. No shared Traefik edits without review/approval. Do not disrupt existing Traefik-routed services.