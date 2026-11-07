<div dir="rtl" align="right">

# دليل أوامر تثبيت Jenkins باستخدام Docker Compose

**Jenkins LTS (JDK 21) · Docker Compose · Traefik HTTPS اختياري · تكامل CI مع Odoo 17/19**

مرجع عملي لتثبيت وتشغيل Jenkins على Ubuntu/Linux (يفضّل تحت `/opt/jenkins`)، مع وضع مستقل ووضع خلف Traefik، وتكامل منفصل مع Odoo 17 وOdoo 19.

- المستودع: https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment
- التوثيق: `README.md`, `docs/`

[التثبيت](#1-التثبيت-تحت-optjenkins) · [تشغيل مستقل](#3-تشغيل-مستقل-http-للتجربة) · [Traefik/HTTPS](#4-تشغيل-خلف-traefik-https--دومين) · [تكامل Odoo](#5-تكامل-odoo-17--19-مجلد-منفصل) · [الصيانة](#6-الصيانة-والنسخ-الاحتياطي)

</div>

---

## المتطلبات

- Ubuntu 22.04/24.04 (أو Linux مناسب) مع Docker Engine وDocker Compose v2 (`docker compose`).
- Git.
- لوضع Traefik: Traefik يعمل، شبكة Docker خارجية `proxy`، DNS للدومين، ومحلل شهادات متوافق (في هذه البيئة: `le`).

تحقق:

```bash
docker --version
docker compose version
```

---

## 1) التثبيت تحت `/opt/jenkins`

```bash
sudo mkdir -p /opt/jenkins
sudo chown "$USER":"$USER" /opt/jenkins
git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/jenkins
cd /opt/jenkins
```

---

## 2) إعداد البيئة والتحقق

```bash
cp .env.example .env
chmod 600 .env
nano .env
docker compose config
docker compose -f docker-compose.traefik.yml config
```

> لا ترفع `.env` إلى Git. عدّل المنافذ/UID/GID/TZ والدومين حسب بيئتك.

---

## 3) تشغيل مستقل (HTTP) للتجربة

```bash
cd /opt/jenkins
docker compose up -d
docker compose ps
docker compose logs -f --tail=100 jenkins
bash scripts/verify.sh
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

افتح: `http://IP_الخادم:8080` (أو `JENKINS_HTTP_PORT`).

---

## 4) تشغيل خلف Traefik (HTTPS + دومين)

اضبط في `.env`:

```env
JENKINS_DOMAIN=jenkins.devops-odoo.com
DOCKER_PROXY_NETWORK=proxy
TRAEFIK_ENTRYPOINT=websecure
CERTSRESOLVER=le
```

شغّل:

```bash
cd /opt/jenkins
docker network create proxy || true
docker compose -f docker-compose.traefik.yml up -d
docker compose -f docker-compose.traefik.yml ps
docker compose -f docker-compose.traefik.yml logs -f --tail=100 jenkins
bash scripts/verify.sh
```

بعد تسجيل الدخول: **Manage Jenkins → System → Jenkins URL** = `https://jenkins.devops-odoo.com/` (أو دومينك).

---

## 5) تكامل Odoo 17 / 19 (مجلد منفصل)

التكامل موجود في `IntegrationOdoo/` ويُدار بشكل مستقل عن تثبيت Jenkins الأساسي.

| النسخة | الرابط المتوقع |
|---|---|
| Odoo 17 | `https://odoo17.devops-odoo.com` |
| Odoo 19 | `https://odoo19.devops-odoo.com` |

الخطوات الأساسية:
1. تأكد من جاهزية Jenkins وTraefik/DNS وOdoo 17/19.
2. أنشئ Credentials في Jenkins (SCM، SSH، tokens) — **لا تضع أسرارًا في Git**.
3. انسخ/كيّف `IntegrationOdoo/pipelines/Jenkinsfile.odoo-addon.example` مع مستودع الإضافات لديك.
4. راجع `IntegrationOdoo/README.md` و`docs/ODOO_INTEGRATION.md`.

ملفات مساعدة (غير سرية): `IntegrationOdoo/odoo17/.env.integration.example`, `IntegrationOdoo/odoo19/.env.integration.example`.

---

## 6) الصيانة والنسخ الاحتياطي

| العملية | الأمر |
|---|---|
| الحالة | `docker compose ps` |
| السجلات | `docker compose logs -f jenkins` |
| إعادة التشغيل | `docker compose restart jenkins` |
| إيقاف مع حفظ البيانات | `docker compose down` |
| تحديث الصورة | `docker compose pull && docker compose up -d` |

نسخ احتياطي (`jenkins_home`):

```bash
docker run --rm -v jenkins_home:/data -v "$(pwd)":/backup alpine \
  tar czf /backup/jenkins_home_$(date +%F).tgz -C /data .
```

اختبر الاستعادة دوريًا. راجع `docs/OPERATIONS.md`.

---

## 7) الأمان (مختصر)

- لا تنشر `.env` أو الأسرار أو بيانات `jenkins_home`.
- قيّد الوصول إلى Jenkins (مستخدمون، صلاحيات، جدار ناري، HTTPS).
- تركيب `/var/run/docker.sock` يمنح Jenkins قدرة عالية على مضيف Docker — استخدمه فقط في بيئة موثوقة مع سياسات وظائف/Credentials صارمة.
- في وضع Traefik: لا تنشر منفذ Jenkins UI مباشرة للعامة.

<div dir="rtl" align="right">

Jenkins LTS · Docker Compose · Traefik (اختياري) · تكامل Odoo 17/19 (منفصل)

</div>
