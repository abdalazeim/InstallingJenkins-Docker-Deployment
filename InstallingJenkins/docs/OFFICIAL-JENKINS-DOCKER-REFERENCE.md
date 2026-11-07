# Jenkins Official Docker Image — Clear Reference Guide

> **Scope:** This is a clear, practical reference based on the official `jenkins/jenkins` Docker image documentation. It is **reference material** for the phased deployment in this repository (`../README.md`, Phase 1 in `../01-Installation/`). **Do not run ad-hoc commands in production without review.** For this project’s gated workflow, use Phase 1 first and record actual test evidence in `../INSTALLATION_REPORT.md`.

## Image
- Docker Hub: https://hub.docker.com/r/jenkins/jenkins/
- Project: https://www.jenkins.io/
- Recommended LTS tag (example): `jenkins/jenkins:lts-jdk21`

## 1) Quick usage (`docker run`)

```bash
docker run -p 8080:8080 -p 50000:50000 --restart=on-failure jenkins/jenkins:lts-jdk21
```

- `8080` — Jenkins web UI.
- `50000` — inbound TCP agent port (see [Agents](#5-agents-and-port-50000)). Not needed for SSH-only/outbound or websocket agents; **do not expose publicly** unless required and secured.
- `--restart=on-failure` (or `unless-stopped`) helps the controller recover.
- If you see *“This Jenkins instance appears to be offline.”* on first boot, check [DNS configuration](#9-dns-troubleshooting-offline-on-first-boot).

## 2) Persistent data (`JENKINS_HOME` = `/var/jenkins_home`)

All Jenkins data lives in `/var/jenkins_home` (jobs, plugins, configuration, secrets, etc.). **Use a named Docker volume** so data survives container replacement/upgrades:

```bash
docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 --restart=on-failure \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk21
```

Docker creates the `jenkins_home` named volume automatically. Volumes persist when the container is stopped, started, or deleted.

**Bind mounts (not recommended):** Mapping a host folder into `/var/jenkins_home` can cause permission issues (container user `jenkins`, uid `1000`). If you must bind-mount, ensure the host directory is accessible to uid `1000` or run with an appropriate `-u` user.

## 3) First-run setup and initial admin password

```bash
# Follow logs (includes setup hints) or read the initial password directly
docker logs <jenkins_container_id_or_name>
docker exec <jenkins_container_id_or_name> cat /var/jenkins_home/secrets/initialAdminPassword
```

Then complete the setup wizard (Jenkins install guide): https://www.jenkins.io/doc/book/installing/docker/#setup-wizard  
In this repo’s Phase 1, create the admin, secure access, and **do not** configure integrations yet.

## 4) Backups (treat `jenkins_home` like a database)

- **Named volume (recommended):** back up/restore the volume content (e.g., temporary container mounting the volume to `tar`/copy). Plan and test restores on non-production.
- **Bind mount (if used):** back up the host directory.
- `docker cp <id>:/var/jenkins_home ...` can extract data from a container; note symlink/copy behavior on some OSes may affect links like `lastStableBuild`.
- Docker volumes: https://docs.docker.com/storage/volumes/

## 5) Agents and port `50000`

- **Recommendation:** do not run builds on the controller’s built-in node (set executors to `0`; see below). Use agents.
- **Inbound TCP agents:** publish `-p 50000:50000` (or your configured agent port).
- **SSH (outbound) agents:** controller connects out; inbound 50000 not required.
- **WebSocket agents:** TCP agent port not used.
- **Security:** restrict 50000 with a firewall/trusted network; never expose unnecessarily.

## 6) Built-in node executors (example)

`executors.groovy`:
```groovy
import jenkins.model.*
Jenkins.instance.setNumExecutors(0) // Recommended: no builds on the built-in node
```

`Dockerfile` (derived image):
```dockerfile
FROM jenkins/jenkins:lts-jdk21
COPY --chown=jenkins:jenkins executors.groovy /usr/share/jenkins/ref/init.groovy.d/executors.groovy
```

## 7) JVM and system properties (`JAVA_OPTS` / `JENKINS_JAVA_OPTS`)

```bash
docker run --name myjenkins -p 8080:8080 -p 50000:50000 --restart=on-failure \
  --env JENKINS_JAVA_OPTS="-Xms512m -Xmx2g" \
  jenkins/jenkins:lts-jdk21
```

- Prefer **`JENKINS_JAVA_OPTS`** for controller-specific JVM options (other tools may read `JAVA_OPTS`).
- System properties: https://www.jenkins.io/doc/book/managing/system-properties/

## 8) Logging (`java.util.logging`)

```bash
mkdir -p data
cat > data/log.properties <<'EOF'
handlers=java.util.logging.ConsoleHandler
jenkins.level=FINEST
java.util.logging.ConsoleHandler.level=FINEST
EOF

docker run --name myjenkins -p 8080:8080 -p 50000:50000 --restart=on-failure \
  --env JAVA_OPTS="-Djava.util.logging.config.file=/var/jenkins_home/log.properties" \
  -v "$(pwd)"/data:/var/jenkins_home \
  jenkins/jenkins:lts-jdk21
```

For user access logs, you can set `JENKINS_OPTS` with an access logger (see official docs); write logs under `/var/jenkins_home/logs/` as appropriate.

## 9) DNS troubleshooting (“offline” on first boot)

If logs show `java.net.UnknownHostException: updates.jenkins.io`, provide DNS servers:

```bash
docker run -p 8080:8080 -p 50000:50000 --restart=on-failure \
  --dns 1.1.1.1 --dns 8.8.8.8 \
  jenkins/jenkins:lts-jdk21
```

In Compose, add `dns: [1.1.1.1, 8.8.8.8]` to the service if needed.

## 10) Reverse proxy / URL prefix (`JENKINS_OPTS`)

Run Jenkins behind a reverse proxy with a prefix (example `/jenkins`):

```bash
-e JENKINS_OPTS="--prefix=/jenkins"
```

Configure the proxy (Apache/Nginx) per Jenkins docs and set the correct Jenkins URL in system configuration. For HTTPS termination/proxying (e.g., Traefik in this repo’s Phase 2), follow the approved, reviewed config and do not modify shared Traefik without approval.

## 11) Jenkins launcher arguments and agent port env

- Extra `docker run` args after the image are passed to the Jenkins launcher (e.g., `--version`).
- `JENKINS_OPTS` customizes launcher args in derived images (also useful for HTTPS/prefix).
- `JENKINS_SLAVE_AGENT_PORT` sets the inbound agent port (system property `jenkins.model.Jenkins.slaveAgentPort`) **unless** already set via `JAVA_OPTS`/`JENKINS_JAVA_OPTS` (then it is ignored). Keep published ports and firewall rules consistent.

## 12) Installing tools / customizing the image

```dockerfile
FROM jenkins/jenkins:lts-jdk21
USER root
RUN apt-get update && apt-get install -y --no-install-recommends <packages> && rm -rf /var/lib/apt/lists/*
USER jenkins
```

Use `/usr/share/jenkins/ref/` to seed default `JENKINS_HOME` content (copied on first init; existing files are not overwritten unless you use `.override` naming per image behavior). Example:
```dockerfile
COPY --chown=jenkins:jenkins custom.groovy /usr/share/jenkins/ref/init.groovy.d/custom.groovy
```
`PRE_CLEAR_INIT_GROOVY_D=true` can reset init scripts behavior in specific scenarios — use with care.

## 13) Preinstalling plugins (`jenkins-plugin-cli`)

```dockerfile
FROM jenkins/jenkins:lts-jdk21
COPY --chown=jenkins:jenkins plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli -f /usr/share/jenkins/ref/plugins.txt
```

- Plugin Installation Manager CLI: https://github.com/jenkinsci/plugin-installation-manager-tool/
- Custom HPI: copy to `/usr/share/jenkins/ref/plugins/`.
- Update center env vars (`JENKINS_UC`, etc.) affect the CLI download behavior, not necessarily the runtime Update Center.
- To pin/avoid post-setup plugin prompts in some 2.x flows, teams sometimes set `jenkins.install.UpgradeWizard.state` — apply only if appropriate for your version/process.

## 14) Docker Compose (example)

```yaml
services:
  jenkins:
    image: jenkins/jenkins:lts-jdk21
    restart: unless-stopped
    ports:
      - "8080:8080"
      - "50000:50000"   # restrict with firewall if used
    volumes:
      - jenkins_home:/var/jenkins_home
    # dns: ["1.1.1.1", "8.8.8.8"]  # if offline/DNS issues
volumes:
  jenkins_home:
```

This repository’s **gated, organized** Compose + scripts live in `../01-Installation/` (Phase 1 only). Use that path for `/opt/InstallingJenkins` deployments and record evidence in `../INSTALLATION_REPORT.md`.

## 15) Upgrading Jenkins and plugins

- **Image/volume model:** with a named `jenkins_home` volume, upgrading is typically `docker compose pull && docker compose up -d` (after backup/verification plan). Always back up first.
- **Plugins:** image/plugin-manager behavior supports upgrades; marker files track image-provided versions. Advanced flags (e.g., `PLUGINS_FORCE_UPGRADE`, `TRY_UPGRADE_IF_NO_MARKER`) change behavior — use deliberately and test.
- **Plugin list updates:** can be generated via `jenkins-plugin-cli` workflows (review diffs before applying).

## 16) Project-specific notes (this repo)
- **Phase 1:** `../01-Installation/` — install only (no Traefik/GitHub/Odoo/Ansible/docker.sock). Gate: `../INSTALLATION_REPORT.md`.
- **Phase 2/3:** `../02-Integration/`, `../03-CICD/` — sequential, tested, evidence in `TEST_REPORT.md`; no production DB/module upgrades without explicit approval + restorable backup.
- **Legacy preserved:** `../legacy/`, `../scripts-archive/` — not deleted.

## References
- https://www.jenkins.io/doc/book/installing/docker/
- https://hub.docker.com/r/jenkins/jenkins
- https://github.com/jenkinsci/docker
- https://github.com/jenkinsci/plugin-installation-manager-tool