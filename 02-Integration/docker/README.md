# Docker Integration (Phase 2)
## Security review first
Avoid full Docker socket access without isolation. Prefer isolated agent or protected remote Docker API with least privilege. `/var/run/docker.sock` = host control risk.
## Test
- [ ] Security approach documented/approved. [ ] Non-destructive build/compose validation pipeline passes.