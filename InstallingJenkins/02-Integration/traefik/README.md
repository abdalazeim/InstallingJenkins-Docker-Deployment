# Traefik Integration (Phase 2)
Target: https://jenkins.devops-odoo.com, Let's Encrypt, HTTP->HTTPS, no direct UI port exposure to internet, proxy network.
## Safety
Do NOT modify shared Traefik settings without review/approval; document any change. Align with existing `proxy` network / resolver `le`.
## Test
- [ ] DNS resolves. [ ] HTTPS valid. [ ] UI reachable via domain. [ ] Data persists after restart.