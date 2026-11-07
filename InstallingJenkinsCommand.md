# InstallingJenkinsCommand — أوامر التثبيت والتشغيل والتكامل

> يعمل على خادم Linux (Ubuntu) مع Docker Engine + Docker Compose v2. المسار الموصى به: `/opt/jenkins`.

## 1) التثبيت تحت `/opt/jenkins`

```bash
sudo mkdir -p /opt/jenkins
sudo chown "$USER":"$USER" /opt/jenkins
git clone https://github.com/abdalazeim/InstallingJenkins-Docker-Deployment.git /opt/jenkins
cd /opt/jenkins
cp .env.example .env
chmod 600 .env
nano .env
```

## 2) فحص الإعداد (قبل التشغيل)

```bash
cd /opt/jenkins
docker --version
docker compose version
docker compose config
# لوضع Traefik:
docker compose -f docker-compose.traefik.yml config
```

## 3) تشغيل Jenkins (وضع مستقل HTTP — مناسب للتجربة)

```bash
cd /opt/jenkins
docker compose up -d
docker compose ps
docker compose logs -f --tail=100 jenkins
bash scripts/verify.sh
```

كلمة مرور المدير الأولية:
```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

افتح: `http://IP_الخادم:8080` (أو قيمة `JENKINS_HTTP_PORT` من `.env`).

## 4) تشغيل Jenkins خلف Traefik (HTTPS + دومين)

المتطلبات: Traefik يعمل، DNS لـ `JENKINS_DOMAIN` يشير للخادم، شبكة Docker خارجية `proxy`، ومحلل الشهادات مطابق (في هذا البيئة: `le`).

في `.env`:
```env
JENKINS_DOMAIN=jenkins.devops-odoo.com
DOCKER_PROXY_NETWORK=proxy
TRAEFIK_ENTRYPOINT=websecure
CERTSRESOLVER=le
```

التشغيل:
```bash
cd /opt/jenkins
docker network create proxy || true
docker compose -f docker-compose.traefik.yml up -d
docker compose -f docker-compose.traefik.yml ps
docker compose -f docker-compose.traefik.yml logs -f --tail=100 jenkins
bash scripts/verify.sh
```

بعد الدخول إلى Jenkins: **Manage Jenkins → System → Jenkins URL** = `https://jenkins.devops-odoo.com/`.

## 5) تكامل Odoo 17 / 19 (مجلد منفصل `IntegrationOdoo/`)

التكامل **منفصل** عن تثبيت Jenkins الأساسي.

| Odoo | URL |
|---|---|
| Odoo 17 | `https://odoo17.devops-odoo.com` |
| Odoo 19 | `https://odoo19.devops-odoo.com` |

خطوات:
1. أكمل إعداد Jenkins وThraefik/DNS/Odoo.
2. أضف Credentials في Jenkins (SCM، SSH deploy، tokens) — **بدون أسرار في Git**.
3. استخدم القالب: `IntegrationOdoo/pipelines/Jenkinsfile.odoo-addon.example` داخل مستودع الإضافات أو كمرجع.
4. راجع: `IntegrationOdoo/README.md` و`docs/ODOO_INTEGRATION.md`.

مثال متغيرات غير سرية: `IntegrationOdoo/odoo17/.env.integration.example`, `IntegrationOdoo/odoo19/.env.integration.example`.

## 6) أوامر الصيانة

```bash
# الحالة
docker compose ps
docker compose logs -f jenkins

# إيقاف (يحافظ على البيانات)
docker compose down

# تحديث الصورة
docker compose pull && docker compose up -d

# نسخ احتياطي لـ jenkins_home
docker run --rm -v jenkins_home:/data -v "$(pwd)":/backup alpine tar czf /backup/jenkins_home_$(date +%F).tgz -C /data .
```

## 7) ملاحظات أمان

- لا ترفع `.env` أو كلمات المرور أو tokens.
- `/var/run/docker.sock` يمنح صلاحيات قوية لوظائف Jenkins — استخدمه فقط في بيئة موثوقة مع تقييد إدارة Jenkins.
- في وضع Traefik لا تنشر منفذ 8080 للعامة؛ أغلق المنافذ غير اللازمة بالجدار الناري.
