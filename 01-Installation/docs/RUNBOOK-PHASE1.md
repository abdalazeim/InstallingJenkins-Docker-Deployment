# ÇáãÑÍáÉ 1 — ÊÔÛíá İÚáí Úáì Ubuntu (ÅáÒÇãí áÇÚÊãÇÏ ÇáÊËÈíÊ)
> **ÇáÍÇáÉ:** áã ÊõäİĞ ÇÎÊÈÇÑÇÊ Docker ÍíÉ ãä ÈíÆÉ ÇáÚãá ÇáÍÇáíÉ. äİøĞ ÇáÃæÇãÑ ÃÏäÇå Úáì Ubuntu ÇáåÏİ¡ Ëã ÍÏøË `../../INSTALLATION_REPORT.md` ÈÇáÎÑÌ ÇáİÚáí.

## ÃæÇãÑ
```bash
cd 01-Installation
bash scripts/preflight.sh                 # ÑÇÌÚ: Jenkins ÓÇÈŞ/ÈíÇäÇÊ¡ ãäÇİĞ¡ ÔÈßÇÊ. áÇ ÊÍĞİ volumes.
cp .env.example .env && chmod 600 .env     # ÚÏøá JENKINS_HTTP_PORT/JENKINS_AGENT_PORT/TZ ÚäÏ ÇáÊÚÇÑÖ
docker compose config
docker compose up -d
sleep 20 && docker compose ps
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword   # Ãæá ÊÔÛíá
# Ãßãá Setup Wizard ãä ÇáãÊÕİÍ (ÔÈßÉ ãæËæŞÉ/VPN)¡ ÃäÔÆ admin¡ áÇ ÊËÈÊ ÅÖÇİÇÊ ÊßÇãá ÇáÂä.
docker compose restart && sleep 20 && docker compose ps                   # ÇÓÊãÑÇÑ ÈíÇäÇÊ
docker volume inspect jenkins_home
docker compose logs --tail=100 jenkins                                   # áÇ ÃÎØÇÁ ÍÑÌÉ
bash scripts/verify.sh                                                   # íÍİÙ verify-output.txt
```

## ŞÈæá ÇáÇäÊŞÇá ááãÑÍáÉ 2 (ßáåÇ ãØáæÈÉ)
- [ ] Jenkins íÚãá æÕÍí/ãÓÊŞÑ.
- [ ] ÇáæÕæá ááæÇÌåÉ äÇÌÍ.
- [ ] ÇáÈíÇäÇÊ (`jenkins_home`) ãÓÊãÑÉ ÈÚÏ ÅÚÇÏÉ ÇáÊÔÛíá (ÇÎÊÈÇÑ İÚáí).
- [ ] ÓáÇãÉ ÇáÊÎÒíä ãÄßÏÉº áÇ ÍĞİ ÈíÇäÇÊ.
- [ ] áÇ ÃÎØÇÁ ÊÔÛíá ÍÑÌÉ.
- [ ] ÇáæÕæá ÇáÃæáí ãÄãøä (admin¡ 50000 ÛíÑ ãßÔæİ ááÅäÊÑäÊ).
- [ ] `INSTALLATION_REPORT.md` ãÍÏË ÈÇáäÊÇÆÌ ÇáİÚáíÉ.

**ÚäÏ ÇáİÔá:** ÊæŞİ¡ ÃÕáÍ¡ ÃÚÏ ÇáÇÎÊÈÇÑ. **áÇ ÊÈÏÃ `02-Integration/` ŞÈá ÊÍŞŞ ßá ÇáÈäæÏ.**