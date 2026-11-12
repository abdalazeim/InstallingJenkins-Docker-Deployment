# Phase 1 hardening notes (apply on Ubuntu target)
# - Keep JENKINS_AGENT_PORT (50000) off the public internet; firewall to trusted agent IPs only, or remove port mapping if no inbound agents.
# - After first login: create admin user, install only required plugins, enable RBAC (Matrix/Role Strategy) in Phase 2 security hardening — but plugin installs that are integration-related wait for Phase 2.
# - Backups: stop-safe snapshot of jenkins_home volume or `docker run --rm -v jenkins_home:/data -v $(pwd):/backup alpine tar czf /backup/jenkins_home.tgz -C /data .` (test restore on non-prod).
# - Do not mount /var/run/docker.sock in Phase 1. Docker integration is Phase 2 with security review.