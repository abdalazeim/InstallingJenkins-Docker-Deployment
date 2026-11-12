# 04-Plugins-AutoInstall — Auto-install Jenkins plugins via Docker

This folder provides a **professional, reusable** way to install a curated set of Jenkins plugins automatically when building the Jenkins image. It is **separate from Phase 1** and can be applied to any Jenkins LTS deployment.

> **Cross-reference:** For the **manual UI-based installation guide** (Phase A) and **complete integration guide** (Phase B), see [`../01-Installation/PLUGINS-INSTALLATION-GUIDE.md`](../01-Installation/PLUGINS-INSTALLATION-GUIDE.md). The plugin list used here matches [`../01-Installation/plugins.txt`](../01-Installation/plugins.txt).

## Why this approach

Instead of manually installing plugins through the Jenkins UI (Manage Jenkins → Plugins → Available), use `jenkins-plugin-cli` inside the Docker build. This:
- Installs plugins and their dependencies deterministically
- Is reproducible when migrating to another server
- Works with CI/CD pipelines
- Avoids manual steps and human error

## Plugins included (24 plugins, 4 groups)

| Group | Plugin IDs |
|---|---|
| **Core** | `git`, `github`, `github-branch-source`, `workflow-aggregator` |
| **Core** | `credentials-binding`, `ssh-agent`, `ws-cleanup` |
| **Core** | `timestamper`, `build-timeout` |
| **Infrastructure** | `docker-workflow`, `ansible`, `ssh-slaves` |
| **Quality & Security** | `sonar`, `warnings-ng` |
| **Quality & Security** | `junit`, `htmlpublisher`, `coverage` |
| **Reporting & Management** | `email-ext` |
| **Reporting & Management** | `role-strategy`, `cloudbees-folder` |
| **Reporting & Management** | `configuration-as-code` |

> Note: Some plugin IDs differ from their display names in the UI (e.g. `workflow-aggregator` for Pipeline). Dependencies are resolved automatically by the Plugin Installation Manager.

## Files

- `plugins.txt` — list of plugin IDs (one per line)
- `Dockerfile` — derived image that installs plugins on build

## How to use

### Step 1: Build the derived image

Inside the `04-Plugins-AutoInstall` folder (or copy it next to your compose file):

```bash
cd /opt/Jenkins--Deployment/04-Plugins-AutoInstall
docker build -t jenkins-with-plugins:latest .
```

### Step 2: Update your Docker Compose

In your `docker-compose.yml`, change the `jenkins` service to use the built image and enable the build:

```yaml
services:
  jenkins:
    build:
      context: ./04-Plugins-AutoInstall
      dockerfile: Dockerfile
    image: jenkins-with-plugins:latest
    container_name: ${JENKINS_CONTAINER_NAME:-jenkins}
    user: "${JENKINS_UID:-1000}:${JENKINS_GID:-1000}"
    restart: unless-stopped
    ports:
      - "${JENKINS_HTTP_PORT:-8080}:8080"
      - "${JENKINS_AGENT_PORT:-50000}:50000"
    environment:
      TZ: ${JENKINS_TZ:-UTC}
    volumes:
      - jenkins_home:/var/jenkins_home
    healthcheck:
      test: ["CMD-SHELL", "curl -fsS http://localhost:8080/login >/dev/null || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 10
      start_period: 90s

volumes:
  jenkins_home:
    name: jenkins_home
```

Keep your existing volumes, network, ports, environment, and restart policy intact.

### Step 3: Start Jenkins

```bash
docker compose build jenkins
docker compose up -d jenkins
sleep 20 && docker compose ps
```

### Step 4: Monitor installation

```bash
docker logs -f jenkins
```

The Plugin Installation Manager downloads all plugins and their dependencies automatically.

## Verify installed plugins

```bash
docker exec jenkins jenkins-plugin-cli --list
```

Or from the Jenkins UI: **Manage Jenkins → Plugins → Installed plugins**.

## Post-install configuration required

Some plugins need additional setup beyond installation:

| Plugin | What you need to configure after install |
|---|---|
| Docker Pipeline | Connect Jenkins to Docker |
| Ansible | Install Ansible on the execution environment |
| SSH Agent | Add SSH credentials |
| SonarQube Scanner | Connect to SonarQube Server |
| Email Extension | Configure SMTP settings |
| Role Strategy | Create roles and permissions |
| Configuration as Code | Create a YAML config file |
| GitHub Branch Source | Add GitHub credentials |

## Notes

- Use official Jenkins Plugin IDs, not UI display names.
- Some plugins (e.g. Pipeline, JUnit) may already exist or be pulled in as dependencies.
- The `jenkins-plugin-cli` resolves most dependencies automatically.
- Always back up `jenkins_home` before upgrading.

## References

- Jenkins Plugin Installation Manager: https://github.com/jenkinsci/plugin-installation-manager-tool
- Official Jenkins Docker image: https://hub.docker.com/r/jenkins/jenkins
- Jenkins docs: https://www.jenkins.io/doc/book/installing/docker/