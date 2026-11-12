# المرحلة 1 — تثبيت Jenkins (دون تكامل)

التشغيل على Ubuntu الهدف (مثال `/opt/jenkins/01-Installation` أو من هذا المسار بعد النسخ):
```bash
cd 01-Installation
cp .env.example .env && chmod 600 .env
# راجع JENKINS_HTTP_PORT/JENKINS_AGENT_PORT وتعارض المنافذ
bash scripts/preflight.sh
docker compose config
docker compose up -d
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
bash scripts/verify.sh   # يلتقط أدلة للتقرير
```

- البيانات دائمة في volume `jenkins_home`. **لا تحذف** الحاوية/الـ volume.
- قيّد المنفذ `50000` بجدار ناري؛ لا تعرض Jenkins للإنترنت دون حماية (المرحلة 2/Traefik لاحقًا بعد نجاح التثبيت).
- بعد الاختبارات الفعلية: حدّث `INSTALLATION_REPORT.md`. **لا تنتقل للمرحلة 2 إلا بنجاح موثق.**

## مراجع المرحلة 1

- **قائمة الإضافات (Plugin IDs):** [`../plugins.txt`](../plugins.txt) — 24 معرّف إضافة رسمي.
- **دليل تثبيت وتكامل الإضافات الكامل:** [`../PLUGINS-INSTALLATION-GUIDE.md`](../PLUGINS-INSTALLATION-GUIDE.md) — يغطي التثبيت عبر واجهة Jenkins (المرحلة أ) والتكوين/التكامل (المرحلة ب).
- **التثبيت التلقائي عبر Docker:** [`../../04-Plugins-AutoInstall/README.md`](../../04-Plugins-AutoInstall/README.md) — بناء صورة مشتقة مع `jenkins-plugin-cli`.