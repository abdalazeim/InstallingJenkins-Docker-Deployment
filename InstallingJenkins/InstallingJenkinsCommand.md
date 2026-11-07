<div dir="rtl" align="right">

# InstallingJenkinsCommand.md — دليل أوامر Jenkins (Docker) بالعربية
## تنظيم مرحلي، نفس الفكرة السابقة (تثبيت أولًا → تكامل بعد نجاح التثبيت → CI/CD)، مع الحفاظ على السكربتات/الملفات القديمة

> **الغرض:** مرجع أوامر واضح لتشغيل Jenkins على Ubuntu عبر Docker داخل المسار `/opt/InstallingJenkins` باستخدام الحزمة المنظمة `InstallingJenkins/`.  
> **تنظيم فقط (بدون حذف):** السكربتات/ملفات التثبيت والنشر القديمة محفوظة في `InstallingJenkins/legacy/` و`InstallingJenkins/scripts-archive/`.  
> **قاعدة أساسية:** لا تدّعِ نجاح اختبار لم يُنفذ. سجّل النتائج الفعلية في `INSTALLATION_REPORT.md`. لا تبدأ المرحلة 2 قبل نجاح المرحلة 1 (PASS).

- المستودع: https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment
- ابدأ من: `InstallingJenkins/README.md` و`InstallingJenkins/INSTALLATION_REPORT.md`
- مرجع صورة Jenkins الرسمية (إنجليزي، واضح): `InstallingJenkins/docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md`

</div>

---

## الفكرة العامة (Phase Gates)
| المرحلة | ماذا نفعل | متى ننتقل |
|---|---|---|
| **1) التثبيت** | Jenkins LTS داخل Docker فقط (Compose + `jenkins_home` دائم + restart + healthcheck). **بدون** Traefik/GitHub/Odoo/Ansible/Docker pipeline/`docker.sock`. | بعد PASS فعلي موثق في `INSTALLATION_REPORT.md` |
| **2) التكامل** (تسلسلي) | `github → docker (مراجعة أمنية أولًا) → ansible → traefik → odoo17 → odoo19`، كل تكامل باختبار مستقل و`TEST_REPORT.md`. | تكامل واحد تلو الآخر؛ لا تنتقل قبل نجاح/توثيق السابق |
| **3) CI/CD** | Pipelines منفصلة لكل مشروع/بيئة/إصدار Odoo (17/19) مع **Manual Approval** قبل الإنتاج. | بعد نجاح تكاملات المرحلة 2 |

---

## المتطلبات (على Ubuntu الهدف)
- Ubuntu 22.04/24.04 (أو Linux مناسب) + Docker Engine + Docker Compose v2 (`docker compose`).
- صلاحيات `sudo` عند الحاجة للنسخ إلى `/opt`.
- للمراحل اللاحقة فقط: Traefik/DNS/شبكة `proxy`، وصول GitHub، بيئات Odoo 17/19 منفصلة، إلخ (خارج نطاق المرحلة 1).

```bash
docker --version
docker compose version
git --version
```

---

## المرحلة 1 — التثبيت فقط (كل الخطوات)

> نفّذ على Ubuntu الهدف (المسار الموصى به `/opt/InstallingJenkins`). **لا تحذف** حاويات/Volumes/بيانات Jenkins الحالية إن وُجدت.

### 1) وضع الملفات تحت `/opt/InstallingJenkins`
> لا تكتب فوق مسار موجود يحتوي بيانات. سكربت `deploy-to-opt.sh` يرفض الاستبدال إذا كان الهدف موجودًا.

```bash
# خيار A: استنساخ المستودع ثم نسخ المجلد المنظم
sudo git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/InstallingJenkins-src
sudo cp -a /opt/InstallingJenkins-src/InstallingJenkins /opt/InstallingJenkins

# خيار B (من نسخة محلية): نسخ آمن إلى /opt دون الكتابة فوق هدف موجود
sudo bash /path/to/InstallingJenkins/01-Installation/scripts/deploy-to-opt.sh /opt/InstallingJenkins
```

### 2) الانتقال إلى مسار التثبيت ومنح صلاحيات التنفيذ
```bash
cd /opt/InstallingJenkins/01-Installation
chmod +x scripts/*.sh
```

### 3) إعداد `.env` (بدون أسرار في Git)
```bash
cp .env.example .env
chmod 600 .env
nano .env   # عدّل عند الحاجة: JENKINS_HTTP_PORT/JENKINS_AGENT_PORT/JENKINS_UID/GID/TZ
```

متغيرات افتراضية مهمة (راجع `.env.example`):
```env
JENKINS_IMAGE=jenkins/jenkins:lts-jdk21
JENKINS_CONTAINER_NAME=jenkins
JENKINS_HTTP_PORT=8080
JENKINS_AGENT_PORT=50000   # قيّد بجدار ناري؛ لا تعرّضه للإنترنت دون حاجة/مراجعة
JENKINS_UID=1000
JENKINS_GID=1000
JENKINS_TZ=UTC
```

### 4) فحص ما قبل التشغيل (Preflight) — بدون حذف بيانات
```bash
bash scripts/preflight.sh
```
راجع الناتج: وجود Jenkins سابق/Volumes، تعارض المنافذ (8080/50000/80/443)، الشبكات. **لا تحذف** أي بيانات.

### 5) التحقق من compose وتشغيل Jenkins
```bash
docker compose config
docker compose up -d
sleep 20
docker compose ps
docker inspect --format 'status={{.State.Status}} health={{if .State.Health}}{{.State.Health.Status}}{{else}}n/a{{end}}' jenkins
```

### 6) الوصول الأولي الآمن (أول تشغيل)
```bash
# تحقق محلي داخل الحاوية
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK

# كلمة المرور الأولية (أول تشغيل فقط)
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
- افتح المتصفح على `http://<IP-الخادم>:8080` (أو المنفذ الذي اخترته) عبر شبكة موثوقة/VPN.
- أكمل Setup Wizard وأنشئ مستخدم admin وفعّل الإعدادات الأمنية الأولية.
- **في المرحلة 1:** لا تربط GitHub/Odoo/Ansible/Traefik، ولا تُعد Docker pipeline، ولا تُثبّت إضافات تكامل غير ضرورية.

### 7) اختبارات الاستمرارية والسلامة (إلزامية — سجّل الدليل)
```bash
# سكربت تحقق يحفظ الدليل (restart + استمرار jenkins_home + logs)
bash scripts/verify.sh   # ينتج 01-Installation/verify-output.txt

# فحوصات إضافية (انسخ خرجها إلى التقرير)
docker compose restart && sleep 20 && docker compose ps
docker volume inspect jenkins_home
docker compose logs --tail=120 jenkins
```
تأكد فعليًا: الواجهة تعمل بعد إعادة التشغيل، بيانات `jenkins_home` مستمرة، لا أخطاء حرجة، الـ volume سليم، والمنفذ 50000 غير مكشوف للعامة.

### 8) تحديث بوابة المرحلة 1 (إلزامي)
حدّث `/opt/InstallingJenkins/INSTALLATION_REPORT.md` بالنتائج الفعلية (أوامر + خرج/ملخص + مرفق `verify-output.txt`) لكل بنود القبول.  
**إذا نجحت كل البنود = PASS موثق** → يمكن البدء بالمرحلة 2 (مراجعة أولًا). **إذا فشل أي بند أساسي** → أصلح وأعد الاختبار و**توقف** عن التكامل.

**بنود القبول:**
- [ ] Jenkins يعمل وبحالة سليمة.
- [ ] الوصول للواجهة ناجح.
- [ ] استمرار البيانات بعد إعادة التشغيل (`jenkins_home`).
- [ ] سلامة التخزين/Volume مؤكدة، بدون حذف بيانات.
- [ ] لا أخطاء تشغيل حرجة في السجلات.
- [ ] وصول أولي آمن (admin + تقييد 50000).

---

## أوامر تشغيل/إيقاف/تشخيص سريعة (Phase 1)
```bash
cd /opt/InstallingJenkins/01-Installation
docker compose ps
docker compose logs -f --tail=100 jenkins
docker compose restart
docker compose down          # يوقف الحاوية؛ لا يحذف volume jenkins_home
# docker compose down -v     # ممنوع إلا بمراجعة واعية — يحذف بيانات Jenkins
```

---

## المرحلة 2 — التكامل (بعد PASS المرحلة 1 فقط)
نفّذ **بالترتيب**، وكل تكامل مستقل + اختبار فعلي + تحديث `TEST_REPORT.md` داخل مجلده. المسار: `InstallingJenkins/02-Integration/`.

| الترتيب | المجلد | الهدف | تنبيه أمان/حوكمة |
|---|---|---|---|
| 1 | `github/` | ربط GitHub (Credentials/Webhook/checkout/pipeline تجريبي) | لا tokens في Git؛ Jenkins Credentials |
| 2 | `docker/` | Docker build/compose validation في CI | **مراجعة أمنية أولًا**؛ تجنب `docker.sock` غير المقيّد (خطر تحكم بالمضيف) |
| 3 | `ansible/` | Jenkins يشغّل Playbooks | اختبار آمن/غير مدمر أولًا (staging/`--check`) |
| 4 | `traefik/` | `https://jenkins.devops-odoo.com` (TLS/redirect/`proxy`) | **لا تعديل Traefik المشترك دون مراجعة/موافقة**؛ توافق resolver `le`/network `proxy` |
| 5 | `odoo17/` | CI/CD لـ Odoo 17 (منفصل عن 19) | Staging أولًا؛ **لا ترقية DB/Modules إنتاج تلقائيًا**؛ موافقة صريحة + نسخة احتياطية قابلة للاستعادة |
| 6 | `odoo19/` | CI/CD لـ Odoo 19 (منفصل عن 17) | نفس ضوابط Odoo 17 |

> تفاصيل وخطوات كل تكامل: `02-Integration/README.md` وملفات README لكل مجلد. لا أسرار في Git. لا نشر إنتاج أو ترقية قواعد بيانات تلقائيًا.

---

## المرحلة 3 — CI/CD (بعد نجاح المرحلة 2)
Pipelines **منفصلة** لكل مشروع/بيئة/إصدار Odoo (17 و19، بدون خلط إعدادات/DB):  
`Checkout → Validation → Static Analysis → Dependency Validation → Automated Tests → Docker Build → Image Validation → Backup Verification → Deploy to Staging → Post-Deployment Tests → **Manual Approval** → Deploy to Production → Health Check → Deployment Report`

**ضوابط إلزامية:** لا نشر إنتاج أو ترقية DB/Modules تلقائيًا. أي إجراء إنتاجي يتطلب **موافقة صريحة + نسخة احتياطية قابلة للاستعادة**. راجع `03-CICD/README.md`.

---

## حفظ القديم (تنظيم فقط — بدون حذف)
- `InstallingJenkins/legacy/` و`InstallingJenkins/scripts-archive/`: نسخ/مراجع للسكربتات وملفات النشر القديمة (bootstrap/compose/verify/status/.env.example/docs/IntegrationOdoo، ومرجع upstream `jenkins*.sh` من commit `5169a68`). استعادة مرجعية: `git show 5169a68:<path>` من المستودع الأصلي. **لا تشغيل إنتاجي للـ legacy دون مراجعة.**

## روابط مرجعية
- دليل الحزمة المنظم: `InstallingJenkins/README.md`
- بوابة المرحلة 1: `InstallingJenkins/INSTALLATION_REPORT.md`
- مرجع Jenkins Docker الرسمي (إنجليزي): `InstallingJenkins/docs/OFFICIAL-JENKINS-DOCKER-REFERENCE.md`
- Jenkins Docker Hub: https://hub.docker.com/r/jenkins/jenkins
- تثبيت Jenkins عبر Docker: https://www.jenkins.io/doc/book/installing/docker/