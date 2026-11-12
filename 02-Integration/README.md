# 02-Integration — ÊäİíĞ ãÊÓáÓá ÈÚÏ äÌÇÍ ÇáãÑÍáÉ 1 İŞØ

**ÈæÇÈÉ ÇáÏÎæá (Gate):** ßá ÈäæÏ ÇáŞÈæá İí `01-Installation/docs/RUNBOOK-PHASE1.md` ãÍŞŞÉ + `../INSTALLATION_REPORT.md` ãÍÏË ÈäÊÇÆÌ İÚáíÉ. æÅáÇ: **ÊæŞİ**.

äİøĞ ÈÇáÊÑÊíÈº **áÇ ÊäÊŞá ááÊÇáí ŞÈá äÌÇÍ/ÊæËíŞ ÇáÓÇÈŞ**:
1. **GitHub** (`github/`) — ãÊØáÈÇÊ/credentials (Jenkins Credentials + Webhook ÓÑøí)¡ ãáİÇÊ ãÓÊŞáÉ¡ ÇÎÊÈÇÑ checkout/webhook ÊÌÑíÈí¡ ÊæËíŞ. áÇ tokens İí Git.
2. **Docker** (`docker/`) — ãÑÇÌÚÉ ÃãäíÉ ÃæáğÇ (ÊÌäÈ docker.sock ÇáßÇãá ÈáÇ ÚÒáº ÈÏíá: agent ãÚÒæá/Remote API ãÍãí). ÈäÇÁ/compose ÊÌÑíÈí Âãä¡ ÊæËíŞ.
3. **Ansible** (`ansible/`) — Jenkins íÔÛøá playbooksº playbook ÊÌÑíÈí Âãä (ÛíÑ ãÏãÑ)¡ ÊæËíŞ.
4. **Traefik** (`traefik/`) — `https://jenkins.devops-odoo.com`, TLS/redirect, ÔÈßÉ `proxy`, áÇ ßÔİ ãäİĞ UI ãÈÇÔÑ ááÅäÊÑäÊ. **áÇ ÊÚÏíá Traefik ÇáãÔÊÑß Ïæä ãÑÇÌÚÉ/ãæÇİŞÉ**º æËøŞ Ãí ÊÛííÑ.
5. **Odoo 17** (`odoo17/`) — ÅÚÏÇÏ ãÓÊŞáº áÇ ÎáØ ãÚ 19/ŞæÇÚÏ ÈíÇäÇÊ.
6. **Odoo 19** (`odoo19/`) — ÅÚÏÇÏ ãÓÊŞá.

áßá ÊßÇãá ÃäÔÆ: `README.md` (ãÍÏøË ÈÇáäÊÇÆÌ)¡ ãáİÇÊ compose/env.example/scripts/Jenkinsfile snippets ÍÓÈ ÇáÍÇÌÉ¡ æ`TEST_REPORT.md` ÈäÊÇÆÌ İÚáíÉ. áÇ ÃÓÑÇÑ İí Git. áÇ äÔÑ/ÊÑŞíÉ DB ÅäÊÇÌ ÊáŞÇÆíğÇ.

## ãÑÇÌÚ ÅÖÇİíÉ
- **Ïáíá ÊËÈíÊ æÊßÇãá ÇáÅÖÇİÇÊ (ÇáãÑÍáÉ È — ÇáÊßÇãá):** [`../01-Installation/PLUGINS-INSTALLATION-GUIDE.md`](../01-Installation/PLUGINS-INSTALLATION-GUIDE.md) — ÃŞÓÇã ãİÕáÉ áßá ÊßÇãá (GitHub¡ Docker¡ Ansible¡ SonarQube¡ SSH Agents¡ Email¡ Role Strategy¡ JCasC¡ Reports).
- **ŞÇÆãÉ ÇáÅÖÇİÇÊ:** [`../01-Installation/plugins.txt`](../01-Installation/plugins.txt)