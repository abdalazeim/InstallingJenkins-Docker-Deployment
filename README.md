# InstallingJenkins — Jenkins (Docker) بتقسيم مرحلي وتنظيم دون فقدان القديم

هذا المجلد هو الحزمة المنظمة لتثبيت Jenkins داخل Docker على Ubuntu، مع فصل صارم بين **التثبيت** و**التكامل** و**CI/CD**. تم تنفيذ العمل كـ**تنظيم فقط**: **لم تُحذف أي سكربتات/ملفات تثبيت قديمة**؛ كل القديم محفوظ للمرجعية.

## الغرض
- استنساخ/نسخ المجلد إلى جهاز Ubuntu (المسار الموصى به: `/opt/InstallingJenkins`) وتشغيل Jenkins عبر Docker.
- تثبيت مستقر أولًا (Phase 1)، ثم تكاملات منفصلة ومختبرة (Phase 2)، ثم Pipelines (Phase 3).
- عدم خلط ملفات التثبيت بالتكامل، وعدم الادعاء بنجاح اختبارات لم تُنفذ.

## التشغيل على الجهاز (Ubuntu + Docker) — المسار `/opt`
> عدّل `<REPO_URL>` إذا كان `InstallingJenkins` جزءًا من مستودع أكبر، أو انسخ المجلد مباشرة إلى `/opt`.

```bash
# الخيار A: استنساخ إلى /opt
sudo git clone <REPO_URL> /opt/InstallingJenkins

# الخيار B: نسخ محلي (لا يكتب فوق هدف موجود — يحافظ على البيانات)
sudo bash /path/to/InstallingJenkins/01-Installation/scripts/deploy-to-opt.sh /opt/InstallingJenkins

# تشغيل المرحلة 1 فقط
cd /opt/InstallingJenkins/01-Installation
chmod +x scripts/*.sh
cp .env.example .env && chmod 600 .env          # لا ترفع .env إلى Git
bash scripts/preflight.sh                        # فحص Jenkins سابق/منافذ/شبكات — لا يحذف بيانات/volumes
docker compose config
docker compose up -d
sleep 20 && docker compose ps
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword  # أول تشغيل فقط
# أكمل Setup Wizard من المتصفح (شبكة موثوقة/VPN)، أنشئ admin. لا تثبت إضافات تكامل الآن.
bash scripts/verify.sh                           # ينتج verify-output.txt (restart + استمرار jenkins_home + logs)
```
بعد ذلك حدّث `INSTALLATION_REPORT.md` بالخرج الفعلي/`verify-output.txt`. **لا تنتقل للمرحلة 2 إلا بعد PASS موثق لكل بنود القبول.**

## هيكل المجلد
| المسار | الدور | الحالة |
|---|---|---|
| `01-Installation/` | تثبيت Jenkins LTS عبر Docker Compose: image LTS، volume دائم `jenkins_home`، `restart: unless-stopped`، `TZ`، healthcheck `/login`، منافذ 8080/50000 قابلة للضبط (`.env`). **بدون** Traefik/GitHub/Odoo/Ansible/Docker pipeline/docker.sock. | جاهز؛ **اختبارات Ubuntu/Docker الفعلية مطلوبة** |
| `02-Integration/` | تكاملات مستقلة ومتسلسلة (كلٌ بملفات/اختبار/`TEST_REPORT.md`): `github → docker (مراجعة أمنية أولًا؛ تجنب docker.sock الكامل بلا عزل) → ansible → traefik (https://jenkins.devops-odoo.com, proxy/`le`، لا تعديل Traefik المشترك دون مراجعة/موافقة) → odoo17 → odoo19` (منفصلان، لا خلط إعدادات/DB). | **غير منفذ** — ممنوع قبل PASS المرحلة 1 |
| `03-CICD/` | Pipelines منفصلة Odoo 17/19: Checkout→Validation→Static Analysis→Deps→Tests→Docker Build→Image Validation→Backup Verification→Staging→Post-Deploy Tests→**Manual Approval**→Production→Health Check→Report. | **غير منفذ** — بعد نجاح المرحلة 2 |
| `legacy/` + `scripts-archive/` | **حفظ القديم (تنظيم فقط، بدون حذف):** `scripts-archive/` نسخ `bootstrap-*`, `status.sh`, `verify.sh`, `.env.example`, `docker-compose*.yml`؛ `legacy/previous-deployment/` (docs/IntegrationOdoo/jenkins init/README/command)؛ `legacy/upstream-jenkins-docker-5169a68/` (`jenkins.sh`, `jenkins-plugin-cli.sh`, `jenkins-support`). استعادة شجرة upstream الكاملة: `git show 5169a68:<path>` من repo الأصلي. لا تشغيل إنتاجي للـ legacy دون مراجعة. | محفوظ |
| `INSTALLATION_REPORT.md` | بوابة المرحلة 1: فحص فعلي موثق + جدول اختبارات مع الدليل. | **غير معتمد للانتقال** حاليًا |

## بوابة الانتقال (Phase Gate)
**لا تبدأ المرحلة 2** إلا بعد تحقق جميعها فعليًا وتوثيقها في `INSTALLATION_REPORT.md`: تشغيل Jenkins، الوصول للواجهة، استمرار البيانات (`jenkins_home`) بعد إعادة التشغيل، سلامة التخزين، لا أخطاء حرجة، تأمين الوصول الأولي (admin + تقييد 50000). عند فشل أي اختبار أساسي: أصلح وأعد الاختبار، ولا تبدأ التكامل. المرحلة 3 بعد نجاح كل تكاملات المرحلة 2.

## قواعد إلزامية
- كل الملفات داخل `InstallingJenkins/`. لا خلط تثبيت/تكامل.
- **لا حذف** بيانات/ملفات/Volumes/**سكربتات قديمة**. لا استبدال Jenkins/بيانات قائمة دون مراجعة.
- لا تعديل إعدادات Odoo أو Traefik المشتركة دون مراجعة/موافقة عند الحاجة؛ وثّق أي تغيير.
- لا أسرار في Git (`.env` مستبعد). لا نشر إنتاج/ترقية DB أو Odoo Modules تلقائيًا دون موافقة صريحة + نسخة احتياطية قابلة للاستعادة.
- لا ادعاء نجاح اختبار لم يُنفذ؛ سجّل الأوامر والخرج الفعلي.