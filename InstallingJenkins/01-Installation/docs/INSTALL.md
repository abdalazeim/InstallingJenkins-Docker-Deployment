# ÇáãÑÍáÉ 1 — ÊËÈíÊ Jenkins (Ïæä ÊßÇãá)

ÇáÊÔÛíá Úáì Ubuntu ÇáåÏİ (ãËÇá `/opt/jenkins/01-Installation` Ãæ ãä åĞÇ ÇáãÓÇÑ ÈÚÏ ÇáäÓÎ):
```bash
cd InstallingJenkins/01-Installation
cp .env.example .env && chmod 600 .env
# ÑÇÌÚ JENKINS_HTTP_PORT/JENKINS_AGENT_PORT æÊÚÇÑÖ ÇáãäÇİĞ
bash scripts/preflight.sh
docker compose config
docker compose up -d
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
bash scripts/verify.sh   # íáÊŞØ ÃÏáÉ ááÊŞÑíÑ
```

- ÇáÈíÇäÇÊ ÏÇÆãÉ İí volume `jenkins_home`. **áÇ ÊÍĞİ** ÇáÍÇæíÉ/ÇáÜ volume.
- ŞíøÏ ÇáãäİĞ `50000` ÈÌÏÇÑ äÇÑíº áÇ ÊÚÑÖ Jenkins ááÅäÊÑäÊ Ïæä ÍãÇíÉ (ÇáãÑÍáÉ 2/Traefik áÇÍŞğÇ ÈÚÏ äÌÇÍ ÇáÊËÈíÊ).
- ÈÚÏ ÇáÇÎÊÈÇÑÇÊ ÇáİÚáíÉ: ÍÏøË `INSTALLATION_REPORT.md`. **áÇ ÊäÊŞá ááãÑÍáÉ 2 ÅáÇ ÈäÌÇÍ ãæËŞ.**