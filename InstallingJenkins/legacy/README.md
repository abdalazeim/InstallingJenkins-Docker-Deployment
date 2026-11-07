# Legacy / archive — حفظ سكربتات وملفات التثبيت القديمة (تنظيم فقط، بدون حذف)
المصدر المحفوظ هنا للاطلاع/المرجعية؛ **لا تُستخدم تلقائيًا** في المرحلة 1 الجديدة.

## `scripts-archive/`
نسخ من ملفات النشر التي كانت في مستودع `InstallingJenkins-Docker-Deployment` (قبل إعادة التنظيم المرحلية): `docker-compose*.yml`, `.env.example`, `bootstrap-*.sh`, `status.sh`, `verify.sh`.

## `upstream-jenkins-docker-5169a68/`
ملفات مرجعية من commit `5169a68` (أول تاريخ المستودع — بناء صورة Jenkins الرسمية upstream): `jenkins.sh`, `jenkins-plugin-cli.sh`, `jenkins-support`. **ملاحظة:** ملفات البناء/الاختبارات الكاملة لذلك التاريخ أُزيلت من شجرة العمل في commit `2e1bea6` (حسب تاريخ git)؛ يمكن استعادتها كاملة عند الحاجة بـ:
```bash
# من نسخة repo الأصلية:
git show 5169a68:<path>
# أو استنساخ commit كامل في مجلد مؤقت (لا يحذف البيانات الحالية)
```

**لا تشغيل إنتاجي لهذه الملفات دون مراجعة.** أسرار/`.env` غير محفوظة هنا.
