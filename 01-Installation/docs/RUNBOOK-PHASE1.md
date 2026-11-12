# المرحلة 1 — تشغيل فعلي على Ubuntu (إلزامي لاعتماد التثبيت)
> **الحالة:** لم تُنفذ اختبارات Docker حية من بيئة العمل الحالية. نفّذ الأوامر أدناه على Ubuntu الهدف، ثم حدّث `../../INSTALLATION_REPORT.md` بالخرج الفعلي.

## أوامر
```bash
cd 01-Installation
bash scripts/preflight.sh                 # راجع: Jenkins سابق/بيانات، منافذ، شبكات. لا تحذف volumes.
cp .env.example .env && chmod 600 .env     # عدّل JENKINS_HTTP_PORT/JENKINS_AGENT_PORT/TZ عند التعارض
docker compose config
docker compose up -d
sleep 20 && docker compose ps
docker exec jenkins curl -fsS http://localhost:8080/login >/dev/null && echo UI_OK
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword   # أول تشغيل
# أكمل Setup Wizard من المتصفح (شبكة موثوقة/VPN)، أنشئ admin، لا تثبت إضافات تكامل الآن.
docker compose restart && sleep 20 && docker compose ps                   # استمرار بيانات
docker volume inspect jenkins_home
docker compose logs --tail=100 jenkins                                   # لا أخطاء حرجة
bash scripts/verify.sh                                                   # يحفظ verify-output.txt
```

## قبول الانتقال للمرحلة 2 (كلها مطلوبة)
- [ ] Jenkins يعمل وصحي/مستقر.
- [ ] الوصول للواجهة ناجح.
- [ ] البيانات (`jenkins_home`) مستمرة بعد إعادة التشغيل (اختبار فعلي).
- [ ] سلامة التخزين مؤكدة؛ لا حذف بيانات.
- [ ] لا أخطاء تشغيل حرجة.
- [ ] الوصول الأولي مؤمّن (admin، 50000 غير مكشوف للإنترنت).
- [ ] `INSTALLATION_REPORT.md` محدث بالنتائج الفعلية.

**عند الفشل:** توقف، أصلح، أعد الاختبار. **لا تبدأ `02-Integration/` قبل تحقق كل البنود.**

## مراجع إضافية
- **قائمة الإضافات:** [`../plugins.txt`](../plugins.txt)
- **دليل تثبيت وتكامل الإضافات (المرحلة أ + ب):** [`../PLUGINS-INSTALLATION-GUIDE.md`](../PLUGINS-INSTALLATION-GUIDE.md)
- **التثبيت التلقائي:** [`../../04-Plugins-AutoInstall/README.md`](../../04-Plugins-AutoInstall/README.md)