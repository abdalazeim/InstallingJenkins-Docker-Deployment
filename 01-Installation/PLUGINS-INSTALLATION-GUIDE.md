# دليل تثبيت وتكامل إضافات Jenkins (Plugins)

> **ملاحظة:** هذا الدليل يغطي مرحلتين مستقلتين: **المرحلة أ** — تثبيت الإضافات عبر واجهة Jenkins، و **المرحلة ب** — تكوين وربط الإضافات بالخدمات الخارجية. لا تبدأ المرحلة ب قبل اجتياز بوابة التحقق في المرحلة أ.

---

## فهرس المحتويات

1. [نظرة عامة](#نظرة-عامة)
2. [المرحلة أ — تثبيت الإضافات عبر واجهة Jenkins](#المرحلة-أ---تثبيت-الإضافات-عبر-واجهة-jenkins)
3. [المرحلة ب — التكوين والتكامل مع الخدمات الخارجية](#المرحلة-ب---التكوين-والتكامل-مع-الخدمات-الخارجية)
4. [قائمة التحقق النهائية](#قائمة-التحقق-النهائية)
5. [المراجع الرسمية](#المراجع-الرسمية)

---

## نظرة عامة

يستخدم هذا المشروع ملف `plugins.txt` الموجود في نفس المجلد (`01-Installation/plugins.txt`) كقائمة مرجعية للإضافات المطلوبة. يحتوي الملف على **24 معرّف إضافة رسمي (Plugin ID)** مقسمة إلى أربع مجموعات:

| المجموعة | الإضافات (Plugin IDs) |
|----------|----------------------|
| **التطوير الأساسي والخطوط الأنبوبية (Core & Pipeline)** | `git`, `github`, `github-branch-source`, `workflow-aggregator`, `credentials-binding`, `ssh-agent`, `ws-cleanup`, `timestamper`, `build-timeout` |
| **البنية التحتية والأتمتة** | `docker-workflow`, `ansible`, `ssh-slaves` |
| **جودة الكود والأمان** | `sonar`, `warnings-ng`, `junit`, `htmlpublisher`, `coverage` |
| **التقارير والإدارة** | `email-ext`, `role-strategy`, `cloudbees-folder`, `configuration-as-code` |

> **ملاحظة هامة:** يتم استخدام معرّفات الإضافات الرسمية (Plugin IDs) كما تظهر في [Jenkins Update Center](https://plugins.jenkins.io/). لا تستخدم الأسماء المعروضة في الواجهة (Display Names) لأنها قد تختلف.

---

# المرحلة أ — تثبيت الإضافات عبر واجهة Jenkins

هذه المرحلة تصف التثبيت اليدوي باستخدام واجهة Jenkins الرسومية. هذه هي الطريقة الأساسية الموثقة. يمكن أيضًا استخدام `plugins.txt` مع أداة `jenkins-plugin-cli` (موثق في `04-Plugins-AutoInstall/README.md`) للتثبيت التلقائي أثناء بناء صورة Docker.

## المتطلبات المسبقة

- Jenkins يعمل ومستقر (المرحلة 1 مكتملة، `INSTALLATION_REPORT.md` محدث).
- الوصول إلى لوحة تحكم Jenkins بحساب `admin`.
- اتصال بالإنترنت لتحميل الإضافات من Update Center.

## خطوات التثبيت

### 1. فتح لوحة تحكم Jenkins
افتح المتصفح وانتقل إلى `http://<الخادم>:8080` (أو المنفذ المحدد في `.env`). سجل الدخول بحساب `admin`.

> **محل صورة توضيحية:** `screenshots/01-jenkins-dashboard.png` — لقطة شاشة للوحة التحكم الرئيسية بعد تسجيل الدخول.

### 2. الانتقال إلى إدارة Jenkins
من القائمة الجانبية، انقر على **Manage Jenkins** (إدارة Jenkins).

> **محل صورة توضيحية:** `screenshots/02-manage-jenkins-menu.png` — القائمة الجانبية مع تحديد "Manage Jenkins".

### 3. فتح صفحة الإضافات
في صفحة "Manage Jenkins"، ابحث عن قسم **Plugins** (الإضافات) وانقر عليه.

> **محل صورة توضيحية:** `screenshots/03-plugins-section.png` — قسم Plugins في صفحة Manage Jenkins.

### 4. تحديد تبويب "Available plugins" (الإضافات المتاحة)
في صفحة الإضافات، اختر تبويب **Available plugins** (الإضافات المتاحة).

> **محل صورة توضيحية:** `screenshots/04-available-plugins-tab.png` — تبويب Available plugins مفعل.

### 5. البحث عن الإضافات باستخدام Plugin ID
استخدم حقل البحث لكتابة **معرّف الإضافة (Plugin ID)** بدقة كما هو مدرج في `plugins.txt`.

> **نصيحة:** ابحث بإضافة واحدة في كل مرة أو بمجموعات صغيرة. المعرّفات حساسة لحالة الأحرف (case-sensitive).

**مثال:** اكتب `github-branch-source` في حقل البحث.

> **محل صورة توضيحية:** `screenshots/05-search-plugin-id.png` — حقل البحث مع إدخال `github-branch-source` والنتيجة الظاهرة.

### 6. تحديد الإضافات المطلوبة
ضع علامة صح (✓) بجانب كل إضافة مطلوبة من القائمة. تأكد من أن الاسم المعروض يطابق Plugin ID في `plugins.txt`.

> **محل صورة توضيحية:** `screenshots/06-select-plugins.png` — عدة إضافات محددة مع علامات صح.

### 7. التثبيت وانتظار حل التبعيات
انقر على زر **Install** (تثبيت). سيقوم Jenkins بـ:
- تحميل الإضافة المختارة.
- حل التبعيات (Dependencies) تلقائيًا وتحميلها.
- عرض شريط تقدم.

> **مهم:** لا تغلق الصفحة أو تعيد تشغيل Jenkins أثناء هذه العملية. انتظر حتى تظهر رسالة "Success" أو "Installed successfully".

> **محل صورة توضيحية:** `screenshots/07-installation-progress.png` — شريط تقدم التثبيت مع حل التبعيات.

### 8. إعادة تشغيل Jenkins عند الضرورة
بعض الإضافات (مثل `workflow-aggregator`، `configuration-as-code`) تتطلب إعادة تشغيل. إذا ظهرت خانة اختيار **"Restart Jenkins when installation is complete and no jobs are running"**، فعّلها وانقر Install.

إذا لم تظهر الخانة، أعد تشغيل Jenkins يدويًا بعد انتهاء التثبيت:

```bash
docker compose restart jenkins
sleep 20 && docker compose ps
```

### 9. التحقق من الإضافات المثبتة
بعد إعادة التشغيل، عد إلى **Manage Jenkins → Plugins → Installed plugins** (الإضافات المثبتة). ابحث عن كل Plugin ID من `plugins.txt` وتأكد من وجودها في القائمة.

> **محل صورة توضيحية:** `screenshots/08-installed-plugins-verified.png` — قائمة الإضافات المثبتة مع وجود جميع الـ 24 إضافة.

### 10. فحص سجلات Jenkins للأخطاء
تفقد السجلات للتأكد من عدم وجود أخطاء حرجة:

```bash
# عرض آخر 100 سطر من سجلات الحاوية
docker logs --tail=100 jenkins

# أو متابعة السجلات مباشرة
docker logs -f jenkins
```

ابحث عن كلمات مثل `ERROR`، `FAILED`، `Plugin installation failed`.

---

## استخدام `plugins.txt` كقائمة تحقق (Checklist)

ملف `plugins.txt` مصمم ليكون **قائمة تحقق يدوية** أثناء التثبيت عبر الواجهة:

1. افتح `plugins.txt` في محرر نصوص.
2. لكل سطر (Plugin ID)، ابحث عنه في تبويب Available plugins.
3. حدده للتثبيت.
4. ضع علامة يدوية (مثل `✓ git`) في نسخة مطبوعة أو في محرر يدعم المهام.

> **ملاحظة:** الأسطر الفارغة في `plugins.txt` تفصل المجموعات فقط ولا تمثل إضافات.

---

## أوامر التحقق من سطر الأوامر

بعد التثبيت وإعادة التشغيل، نفّذ الأوامر التالية لتوثيق الأدلة:

```bash
# 1. حالة الحاويات
docker compose ps

# 2. سجلات Jenkins (آخر 200 سطر)
docker logs --tail=200 jenkins

# 3. قائمة الإضافات المثبتة داخل الحاوية
docker exec jenkins ls -la /var/jenkins_home/plugins/ | head -30

# 4. استخدام jenkins-plugin-cli لعرض الإضافات (إذا متاح)
docker exec jenkins jenkins-plugin-cli --list 2>/dev/null || echo "jenkins-plugin-cli not available in base image"
```

> **قاعدة ذهبية:** لا تدّعي نجاح التثبيت دون مخرجات الأوامر أعلاه موثقة في `INSTALLATION_REPORT.md` أو `TEST_REPORT.md` المناسب.

---

# المرحلة ب — التكوين والتكامل مع الخدمات الخارجية

> **مبدأ أساسي:** تثبيت الإضافة **لا يعني** تكوين الخدمة الخارجية تلقائيًا. كل إضافة تحتاج إلى تكوين صريح (Credentials، URLs، مفاتيح، صلاحيات) قبل أن تعمل في الخطوط الأنبوبية (Pipelines).

هذا القسم يغطي تسع تكاملات رئيسية. نفّذها **بالتسلسل**، ووثّق كل واحدة في `TEST_REPORT.md` خاص بها (كما هو موثق في `02-Integration/README.md`). لا تنتقل للتكامل التالي قبل نجاح الحالي.

---

## 1. تكامل GitHub (GitHub Integration)

### الإضافات ذات الصلة
- `git` — عميل Git الأساسي.
- `github` — واجهة GitHub API.
- `github-branch-source` — دعم Multibranch Pipeline و Organization Folders.
- `credentials-binding` — حقن الأسرار في متغيرات بيئة البناء.

### خطوات التكوين

#### أ. حساب GitHub ومستودع (Repository)
- تأكد من وجود حساب GitHub (منظمة أو مستخدم) ومستودع هدف.
- المستودع يجب أن يحتوي على `Jenkinsfile` للخطوط الأنبوبية.

#### ب. إنشاء Personal Access Token (PAT)
1. في GitHub: **Settings → Developer settings → Personal access tokens → Tokens (classic)**.
2. انقر **Generate new token (classic)**.
3. امنح الصلاحيات التالية (الأقل امتيازًا):
   - `repo` (كامل: `repo:status`, `repo_deployment`, `public_repo`, `repo:invite`, `security_events`)
   - `admin:repo_hook` (لإنشاء/إدارة Webhooks)
   - `read:org` (لقراءة عضوية المنظمة في Multibranch)
   - `workflow` (إذا تستخدم GitHub Actions بجانب Jenkins)
4. **انسخ التوكن فورًا** — لن يظهر مجددًا.

> **أمان:** لا تخزن PAT في الكود أو ملفات `.env` المشتركة. استخدم Jenkins Credentials فقط.

#### ج. إضافة الـ Credentials في Jenkins
1. **Manage Jenkins → Credentials → System → Global credentials (unrestricted) → Add Credentials**.
2. **Kind:** `Username with password`.
3. **Username:** اسم مستخدم GitHub (أو `git`).
4. **Password:** الصق الـ PAT هنا.
5. **ID:** `github-pat` (أو معرف وصفي ثابت، يُستخدم في `Jenkinsfile`).
6. **Description:** `GitHub PAT for Jenkins integration`.

> **محل صورة توضيحية:** `screenshots/09-github-credentials.png` — نموذج إضافة Credentials مع نوع Username with password.

#### د. تكوين GitHub Server (اختياري لـ GitHub Enterprise)
- **Manage Jenkins → Configure System → GitHub Servers**.
- أضف خادمًا: Name: `github.com`، API URL: `https://api.github.com`.
- Credentials: اختر الـ Credentials المنشأة أعلاه.
- Test Connection → يجب أن تظهر "Verify credentials: Success".

#### ه. تكوين GitHub Branch Source
في إعدادات Multibranch Pipeline أو Organization Folder:
- **Scan Credentials:** اختر `github-pat`.
- **Behaviors:** أضف "Discover branches"، "Discover PRs from origin"، "Discover PRs from forks" حسب الحاجة.

#### و. إعداد Webhook في GitHub
1. في المستودع على GitHub: **Settings → Webhooks → Add webhook**.
2. **Payload URL:** `http://<jenkins-host>:8080/github-webhook/` (أو `https://jenkins.devops-odoo.com/github-webhook/` بعد Traefik).
3. **Content type:** `application/json`.
4. **Secret:** أنشئ سرًا عشوائيًا قويًا (مثل `openssl rand -hex 20`). خزنه في Jenkins Credentials كـ `Secret text` بـ ID `github-webhook-secret`.
5. **Events:** اختر "Push events"، "Pull requests"، "Branch or tag creation".
6. **Active:** ✓.

> **مهم:** بعد تكوين Traefik (المرحلة 2.4)، حدّث Payload URL لاستخدام HTTPS والنطاق الرسمي.

#### ز. إنشاء Multibranch Pipeline للاختبار
1. **New Item → Multibranch Pipeline**.
2. Name: `test-github-integration`.
3. **Branch Sources → Add source → GitHub**.
4. **Credentials:** `github-pat`.
5. **Owner:** اسم المنظمة أو المستخدم.
6. **Repository:** اختر المستودع التجريبي.
7. **Behaviors:** اكتشف الفروع و PRs.
8. **Build Configuration:** Mode: `by Jenkinsfile`، Script Path: `Jenkinsfile`.
9. **Scan Multibranch Pipeline Triggers:** افتراضي أو جدولة دورية.
10. Save → انقر **Scan Multibranch Pipeline Now**.

#### ح. اختبار Checkout المستودع
في `Jenkinsfile` التجريبي:

```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                sh 'ls -la'
            }
        }
    }
}
```

شغّل البناء وتأكد من نجاح مرحلة Checkout.

> **محل صورة توضيحية:** `screenshots/10-multibranch-scan-success.png` — نتيجة الفحص الناجح مع اكتشاف الفروع.

---

## 2. تكامل Docker (Docker Integration)

### الإضافات ذات الصلة
- `docker-workflow` (Docker Pipeline) — خطوات `docker`، `docker.image`، `docker.withRegistry` في Pipeline.
- `ssh-agent` — لإدارة مفاتيح SSH عند السحب من مستودعات خاصة.

### متطلبات ما قبل التكوين

#### أ. توفر Docker CLI
الصورة الأساسية `jenkins/jenkins:lts-jdk21` **لا تحتوي على Docker CLI**. لديك خياران:

| الخيار | الوصف | الأمان |
|--------|---------|--------|
| **وكيل (Agent) منفصل مع Docker** | استخدم عقدة بناء (Agent) عليها Docker مثبت ومهيأ. Jenkins Controller لا يلمس Docker. | **الأكثر أمانًا** — موصى به للإنتاج. |
| **تثبيت Docker في صورة Jenkins المخصصة** | أضف `RUN apt-get update && apt-get install -y docker.io` في Dockerfile مخصص. | يتطلب توصيل Docker Socket — مخاطرة عالية. |

> **توصية قوية:** استخدم **وكيل بناء منفصل** (Docker Agent) معزول. لا تعرض `/var/run/docker.sock` للتحكم (Controller) إلا بعد مراجعة أمنية رسمية وموافقة مكتوبة.

#### ب. اتصال Docker Engine
إذا اخترت وكيلًا منفصلًا:
- ثبّت Docker Engine على خادم الوكيل: `sudo apt-get install -y docker.io`.
- أضف مستخدم `jenkins` لمجموعة `docker`: `sudo usermod -aG docker jenkins` (أعد تسجيل الدخول).
- تأكد من عمل `docker version` و `docker run hello-world` على الوكيل.

#### ج. إضافة Credentials لمستودع Docker (Registry)
1. **Manage Jenkins → Credentials → Add Credentials**.
2. **Kind:** `Username with password` (أو `Docker Host Certificate Authentication` لـ TLS).
3. **Username:** مستخدم Docker Hub / Registry.
4. **Password:** توكن الوصول (Access Token) أو كلمة المرور.
5. **ID:** `docker-registry-creds`.
6. **Description:** `Docker Registry credentials for pipeline`.

---

### تكوين Docker Pipeline في Jenkinsfile

```groovy
pipeline {
    agent { label 'docker-agent' }  // وكيل عليه Docker
    environment {
        REGISTRY = 'docker.io/myorg'
        IMAGE_NAME = 'myapp'
        // حقن Credentials بأمان
        DOCKER_CREDS = credentials('docker-registry-creds')
    }
    stages {
        stage('Build Image') {
            steps {
                script {
                    dockerImage = docker.build("${REGISTRY}/${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }
        stage('Test Image') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'echo "Running tests inside container..."'
                        // sh 'pytest' أو أوامر اختبار أخرى
                    }
                }
            }
        }
        stage('Push Image') {
            when { branch 'main' }
            steps {
                script {
                    docker.withRegistry("https://${REGISTRY}", 'docker-registry-creds') {
                        dockerImage.push("${BUILD_NUMBER}")
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}
```

---

### مخاطر أمان Docker Socket

| المخاطر | الوصف | التخفيف |
|---------|---------|---------|
| **تحكم كامل في المضيف** | الوصول إلى `/var/run/docker.sock` = صلاحيات root على المضيف. | لا تركب الـ socket في Controller. استخدم وكيلًا معزولًا. |
| **هروب الحاوية (Container Escape)** | حاوية خبيثة تسيطر على Docker Daemon. | مستخدم غير جذري، seccomp، AppArmor، rootless Docker. |
| **تسريب الأسرار** | متغيرات البيئة والأحجام المكشوفة. | استخدم `docker.withRegistry` مع Credentials، لا تخزن أسرار في الصور. |

> **قاعدة:** لا تركب `/var/run/docker.sock` في Jenkins Controller دون:
> 1. مراجعة أمنية موثقة.
> 2. موافقة مكتوبة من مالك البنية التحتية.
> 3. توثيق خطة التخفيف في `02-Integration/docker/TEST_REPORT.md`.

---

### اختبار بناء وتشغيل تجريبي

على الوكيل (Agent) الذي عليه Docker:

```bash
# اختبار يدوي أولاً
docker run --rm hello-world
docker build -t test-image:local -f Dockerfile.test .
docker run --rm test-image:local echo "Success"
```

ثم في Jenkins، شغّل Pipeline تجريبيًا يستخدم `docker.build` و `docker.push` (إلى مستودع تجريبي).

> **محل صورة توضيحية:** `screenshots/11-docker-pipeline-success.png` — بناء ناجح مع خطوات Docker.

---

## 3. تكامل Ansible (Ansible Integration)

### الإضافات ذات الصلة
- `ansible` — يوفر خطوات `ansiblePlaybook`، `ansibleVault`، وإدارةInventory في Pipeline.
- `ssh-agent` — لحقن مفاتيح SSH الخاصة عند الاتصال بالعقد المستهدفة.

### المتطلبات

#### أ. تثبيت Ansible في بيئة التنفيذ
على **جيم Jenkins الذي سيشغل الـ playbooks** (Controller أو Agent):

```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y ansible sshpass

# التحقق
ansible --version
ansible-playbook --version
```

> **ملاحظة:** إذا تستخدم وكيلًا منفصلًا للبناء (Agent)، ثبّت Ansible هناك. الـ Controller لا يحتاج Ansible إذا كان يفوض التنفيذ للوكيل.

#### ب. تكوين SSH Credentials
1. أنشئ زوج مفاتيح SSH للـ Jenkins (إذا لم يكن موجودًا):
   ```bash
   ssh-keygen -t ed25519 -f ~/.ssh/jenkins_ansible -N ""
   ```
2. أضف المفتاح العام (`jenkins_ansible.pub`) إلى `~/.ssh/authorized_keys` على الخوادم المستهدفة.
3. في Jenkins: **Credentials → Add Credentials**.
   - **Kind:** `SSH Username with private key`.
   - **Username:** `ubuntu` أو `root` أو مستخدم النشر.
   - **Private Key:** `Enter directly` → الصق محتوى `jenkins_ansible` (المفتاح الخاص).
   - **Passphrase:** اتركها فارغة إذا المفتاح بلا جملة مرور.
   - **ID:** `ansible-ssh-key`.
   - **Description:** `SSH key for Ansible deployment`.

#### ج. إدارة Inventory (المخزون)
- **Static Inventory:** ملف `hosts` أو `inventory.yml` في المستودع (لا تضع IPs إنتاج حقيقية في Git — استخدم متغيرات بيئة أو Credentials).
- **Dynamic Inventory:** سكريبت يجلب المخزون من AWS EC2، Azure، VMware، إلخ.
- في Pipeline، مرر مسار المخزون كمتغير أو ملف.

#### د. مسار تثبيت Ansible
تأكد من أن `ansible` و `ansible-playbook` في `PATH` للمستخدم الذي يشغل Jenkins:
```bash
which ansible
# يجب أن يُظهر: /usr/bin/ansible
```
إذا كان في مسار غير قياسي، أضف `ansibleInstallation` في إعدادات الإضافة أو عدل `PATH` في Jenkinsfile.

---

### اختبار الاتصال بخادم مستهدف

```bash
# من بيئة تنفيذ Jenkins (Controller أو Agent)
ansible all -i "target-host," -m ping -u ubuntu --private-key ~/.ssh/jenkins_ansible
```

النتيجة المتوقعة:
```json
target-host | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

---

### تنفيذ Playbook تجريبي (غير مدمر)

أنشئ `test-playbook.yml`:

```yaml
---
- name: Test Ansible connectivity
  hosts: all
  become: false
  tasks:
    - name: Gather facts
      setup:

    - name: Show hostname
      debug:
        msg: "Connected to {{ inventory_hostname }} ({{ ansible_host }})"

    - name: Check disk space (read-only)
      command: df -h /
      register: disk
      changed_when: false

    - name: Report disk
      debug:
        var: disk.stdout_lines
```

شغّله من Jenkins Pipeline:

```groovy
pipeline {
    agent { label 'ansible-agent' }
    stages {
        stage('Ansible Test') {
            steps {
                ansiblePlaybook(
                    installation: 'ansible',  // إذا عرّفت أداة في Global Tool Configuration
                    playbook: 'test-playbook.yml',
                    inventory: 'hosts',
                    credentialsId: 'ansible-ssh-key',
                    become: false
                )
            }
        }
    }
}
```

> **محل صورة توضيحية:** `screenshots/12-ansible-playbook-success.png` — تنفيذ Playbook ناجح مع مخرجات المهام.

---

## 4. تكامل SonarQube (SonarQube Integration)

### الإضافات ذات الصلة
- `sonar` (SonarQube Scanner for Jenkins) — يضيف خطوة `withSonarQubeEnv` وأدوات الماسح.

### المتطلبات

#### أ. خادم SonarQube
- SonarQube مثبت ويمكن الوصول إليه من شبكة Jenkins (مثلاً `http://sonarqube:9000` أو `https://sonar.company.com`).
- إصدار متوافق مع الإضافة (تحقق من مصفوفة التوافق في صفحة إضافة `sonar`).

#### ب. تكوين عنوان الخادم في Jenkins
1. **Manage Jenkins → Configure System → SonarQube Servers**.
2. انقر **Add SonarQube**.
3. **Name:** `SonarQube-Prod` (اسم وصفي).
4. **Server URL:** `http://sonarqube:9000` (أو URL العام).
5. **Credentials:** أضف Credentials من نوع `Secret text` للتوكن (الخطوة التالية).
6. **Test Connection** — يجب أن ينجح.

#### ج. إنشاء توكن مصادقة (Authentication Token) في SonarQube
1. في SonarQube UI: **My Account → Security → Generate Tokens**.
2. Name: `jenkins-scanner`، Type: `Global Analysis Token`.
3. انسخ التوكن فورًا.

#### د. تخزين التوكن في Jenkins Credentials
1. **Credentials → Add Credentials**.
2. **Kind:** `Secret text`.
3. **Secret:** الصق توكن SonarQube.
4. **ID:** `sonarqube-token`.
5. **Description:** `SonarQube Global Analysis Token for Jenkins`.

#### ه. تكوين SonarQube Scanner
- الإضافة `sonar` تجلب الماسح تلقائيًا عند الاستخدام الأول، أو يمكنك تعريف أداة `SonarQube Scanner` في **Manage Jenkins → Tools → SonarQube Scanner → Add** (اختر "Install automatically" أو حدد مسارًا يدويًا).

---

### اختبار مسح مشروع نموذجي

في مستودع تجريبي، أضف `sonar-project.properties` في الجذر:

```properties
sonar.projectKey=test-project
sonar.projectName=Test Project
sonar.sources=src
sonar.language=py  # أو java, js, ts, إلخ
sonar.sourceEncoding=UTF-8
```

Jenkinsfile للاختبار:

```groovy
pipeline {
    agent any
    environment {
        SONAR_TOKEN = credentials('sonarqube-token')
    }
    stages {
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube-Prod') {
                    sh 'sonar-scanner'
                }
            }
        }
    }
}
```

شغّل البناء وتأكد من:
1. ظهور "SonarQube analysis completed" في Console Output.
2. في SonarQube UI، المشروع `test-project` يظهر مع نتائج المسح.

> **محل صورة توضيحية:** `screenshots/13-sonarqube-analysis-success.png` — نتائج المسح في واجهة SonarQube.

---

## 5. وكلاء بناء SSH (SSH Build Agents)

### الإضافات ذات الصلة
- `ssh-slaves` (SSH Build Agents) — يدير اتصال SSH بالعقد البعيدة.
- `ssh-agent` — يحقن مفاتيح SSH في خطوات البناء.

### التكوين

#### أ. إعداد اتصال SSH على الوكيل (Agent Node)
على كل خادم سيصبح وكيل بناء:
1. أنشئ مستخدم `jenkins` (أو استخدم مستخدمًا موجودًا):
   ```bash
   sudo useradd -m -s /bin/bash jenkins
   sudo usermod -aG docker jenkins  # إذا يحتاج Docker
   ```
2. أنشئ زوج مفاتيح SSH لـ Controller (إذا لم يكن موجودًا):
   ```bash
   # على Controller (حاوية Jenkins)
   docker exec -u jenkins jenkins ssh-keygen -t ed25519 -f /var/jenkins_home/.ssh/jenkins_agent -N ""
   ```
3. انسخ المفتاح العام إلى الوكيل:
   ```bash
   # من Controller إلى Agent
   docker exec jenkins cat /var/jenkins_home/.ssh/jenkins_agent.pub | ssh user@agent-host "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh"
   ```
4. اختبر الاتصال من Controller:
   ```bash
   docker exec -u jenkins jenkins ssh -i /var/jenkins_home/.ssh/jenkins_agent jenkins@agent-host "echo Connected successfully"
   ```

#### ب. إضافة Agent Credentials في Jenkins
1. **Manage Jenkins → Credentials → Add Credentials**.
2. **Kind:** `SSH Username with private key`.
3. **Username:** `jenkins` (مستخدم الوكيل).
4. **Private Key:** `Enter directly` → الصق محتوى `/var/jenkins_home/.ssh/jenkins_agent` (المفتاح الخاص).
5. **ID:** `ssh-agent-key`.
6. **Description:** `SSH key for Jenkins build agents`.

#### ج. تكوين الوكيل (Node) في Jenkins
1. **Manage Jenkins → Nodes → New Node**.
2. **Name:** `docker-agent` (أو اسم وصفي).
3. **Type:** `Permanent Agent`.
4. **Remote root directory:** `/home/jenkins/agent` (مسار على الوكيل حيث سيتم إنشاء مساحة العمل).
5. **Labels:** `docker-agent ansible-agent` (علامات للاختيار في Pipeline).
6. **Launch method:** `Launch agents via SSH`.
   - **Host:** IP أو اسم مضيف الوكيل.
   - **Credentials:** `ssh-agent-key`.
   - **Host Key Verification Strategy:** `Known hosts file verification strategy` (الأكثر أمانًا) أو `Manually trusted key verification strategy` للاختبار فقط.
7. **Availability:** `Keep this agent online as much as possible`.
8. Save.

#### د. التحقق من اتصال الوكيل
في صفحة الـ Node، انقر **Launch agent** أو انتظر الاتصال التلقائي. يجب أن تظهر أيقونة خضراء وحالة "Online".

> **محل صورة توضيحية:** `screenshots/14-ssh-agent-online.png` — الوكيل متصل وحالته Online.

#### ه. تنفيذ مهمة اختبار على الوكيل
Jenkinsfile:

```groovy
pipeline {
    agent { label 'docker-agent' }
    stages {
        stage('Test Agent') {
            steps {
                sh '''
                    echo "Running on: $(hostname)"
                    echo "User: $(whoami)"
                    echo "Docker: $(docker --version)"
                    echo "Ansible: $(ansible --version | head -1)"
                '''
            }
        }
    }
}
```

شغّل وتأكد من نجاح البناء على الوكيل البعيد.

---

## 6. إشعارات البريد الإلكتروني (Email Notifications)

### الإضافات ذات الصلة
- `email-ext` (Email Extension Plugin) — يدعم قوالب، مرفقات، مشغلات متقدمة.

### التكوين

#### أ. تكوين SMTP في Jenkins
1. **Manage Jenkins → Configure System → Extended E-mail Notification**.
2. **SMTP server:** `smtp.gmail.com` (أو خادم SMTP الخاص بك).
3. **SMTP Port:** `587` (TLS) أو `465` (SSL) أو `25` (غير مشفر — غير مستحسن).
4. **Credentials:** أضف Credentials من نوع `Username with password`:
   - Username: بريد المرسل (مثل `jenkins@company.com`).
   - Password: **كلمة مرور التطبيق (App Password)** — ليست كلمة مرور الحساب الرئيسية.
   - ID: `smtp-credentials`.
5. **Default Recipients:** قائمة بريدية افتراضية (اختياري).
6. **Default Subject / Content:** اتركها فارغة للاستخدام القوالب.
7. انقر **Test configuration by sending test e-mail** → أدخل بريدًا تجريبيًا → تأكد من الاستلام.

#### ب. تكوين نظام البريد الأساسي (للإشعارات البسيطة)
**Manage Jenkins → Configure System → E-mail Notification**:
- نفس إعدادات SMTP أعلاه.
- **System Admin e-mail address:** بريد مسؤول النظام.

#### ج. تخزين Credentials بأمان
- **لا** تضع كلمة مرور SMTP في `Jenkinsfile` أو `.env` أو Git.
- استخدم `credentials('smtp-credentials')` في Pipeline عند الحاجة لإرسال مخصص.

---

### إرسال إشعار تجريبي

في Pipeline:

```groovy
pipeline {
    agent any
    stages {
        stage('Test Email') {
            steps {
                emailext (
                    subject: "Jenkins Test - Build ${BUILD_NUMBER} - ${currentBuild.currentResult}",
                    body: '''
                        <h3>Test Email from Jenkins</h3>
                        <p>Build: ${BUILD_URL}</p>
                        <p>Status: ${currentBuild.currentResult}</p>
                    ''',
                    to: 'devops-team@company.com',
                    mimeType: 'text/html',
                    credentialsId: 'smtp-credentials'
                )
            }
        }
    }
}
```

أو باستخدام خطوة `mail` البسيطة (بدون `email-ext`):

```groovy
mail to: 'devops@company.com',
     subject: 'Jenkins Test',
     body: 'Test email from Pipeline'
```

> **محل صورة توضيحية:** `screenshots/15-email-test-received.png` — البريد التجريبي مستلم في صندوق الوارد.

---

## 7. تفويض الوصول القائم على الأدوار (Role-Based Authorization)

### الإضافات ذات الصلة
- `role-strategy` (Role-based Authorization Strategy) — يحدد أدوارًا عالمية، للمشروع، وللملفات.

### تفعيل استراتيجية التفويض
1. **Manage Jenkins → Configure Global Security → Authorization**.
2. اختر **Role-Based Strategy**.
3. Save.

### إنشاء الأدوار الموثقة

بعد التفعيل، تظهر قائمة **Manage and Assign Roles** في Manage Jenkins.

#### أ. أدوار عالمية (Global Roles)
انتقل إلى **Manage Roles → Global Roles**. أضف الأدوار التالية:

| الدور (Role ID) | الاسم المعروض | الصلاحيات (Permissions) | الوصف |
|----------------|---------------|------------------------|-------|
| `admin` | Administrator | **Overall: جميع الصلاحيات** (Admin, Read, RunScripts, UploadPlugins, ConfigureUpdateCenter) | وصول كامل للنظام، إدارة الإضافات، الإعدادات العامة، المستخدمين. |
| `devops` | DevOps Engineer | **Overall:** Read, RunScripts<br>**Credentials:** Create, Delete, ManageDomains, Update, View<br>**Job:** Build, Cancel, Configure, Create, Delete, Discover, Read, Workspace<br>**Run:** Delete, Replay, Update<br>**View:** Create, Delete, Configure, Read<br>**Agent:** Build, Configure, Create, Delete, Disconnect, Connect | إدارة الخطوط الأنبوبية، Credentials، الوكلاء، المشاهدات. لا يدير الإضافات العامة أو إعدادات النظام الحساسة. |
| `developer` | Developer | **Job:** Build, Cancel, Discover, Read, Workspace<br>**Run:** Replay, Update<br>**View:** Read<br>**Agent:** Build | تشغيل البناء، عرض النتائج، إعادة تشغيل (Replay)، الوصول لمساحة العمل. لا ينشئ/يحذف وظائف أو يدير Credentials. |
| `viewer` | Viewer | **Overall:** Read<br>**Job:** Discover, Read<br>**Run:** Read<br>**View:** Read | قراءة فقط — لوحات معلومات، تقارير، حالة البناء. لا تنفيذ أي إجراء. |

> **مهم:** استخدم **Role IDs** بالإنجليزية الصغيرة (كما في العمود الأول) لأنها تُستخدم في التعيين البرمجي والبرمجيات النصية.

#### ب. أدوار المشروع (Project Roles)
في تبويب **Project Roles**، أضف أنماطًا (Patterns) للتحكم الدقيق:

| النمط (Pattern) | الدور | الصلاحيات |
|----------------|-------|----------|
| `prod-*` | `devops` | Job: Configure, Create, Delete, Build, Cancel, Read, Workspace |
| `staging-*` | `developer` | Job: Build, Cancel, Read, Workspace |
| `feature-*` | `developer` | Job: Build, Cancel, Read, Workspace |
| `*-report` | `viewer` | Job: Read, Discover |

> الأنماط تستخدم تعبيرات منتظمة (Java regex). `prod-*` يطابق أي وظيفة تبدأ بـ `prod-`.

#### ج. تعيين الأدوار للمستخدمين/المجموعات
انتقل إلى **Assign Roles**:
- أضف مستخدمين أو مجموعات (من LDAP/SAML/OAuth إذا مهيأ، أو مستخدمين محليين).
- فعّل مربعات الاختيار للأدوار العالمية المناسبة لكل مستخدم.
- للمشروع، فعّل الأدوار حسب النمط لكل مستخدم/مجموعة.

> **محل صورة توضيحية:** `screenshots/16-role-assignment.png` — مصفوفة تعيين الأدوار مع مستخدمين وأدوار.

---

## 8. التكوين ككود (Configuration as Code - JCasC)

### الإضافات ذات الصلة
- `configuration-as-code` — يسمح بتعريف إعدادات Jenkins في ملف YAML إعلاني.

### هندسة JCasC

JCasC يعمل كطبقة تكوين إعلانية فوق Jenkins:
- يقرأ ملف `jenkins.yaml` (أو عدة ملفات) عند بدء التشغيل.
- يطبق الإعدادات: أمن، أدوات، Credentials (مراجع فقط)، وظائف، عروض، إلخ.
- يدعم إعادة التحميل الآمن دون إعادة تشغيل كاملة (`Manage Jenkins → Configuration as Code → Reload`).

> **مبدأ الأمان:** **لا تضع كلمات مرور أو توكنات مباشرة في `jenkins.yaml`**. استخدم مراجع لمتغيرات بيئة أو Credentials مخزنة في Jenkins.

---

### مثال `jenkins.yaml` أساسي

أنشئ ملف `jenkins.yaml` في مسار معروف (مثل `/var/jenkins_home/casc/jenkins.yaml`) وأشر إليه بمتغير بيئة `CASC_JENKINS_CONFIG`.

```yaml
jenkins:
  systemMessage: "Jenkins configured via JCasC - ${JENKINS_URL}"
  numExecutors: 2
  mode: NORMAL
  labelString: "controller"
  securityRealm:
    local:
      allowsSignup: false
      users:
        - id: "admin"
          name: "Administrator"
          password: "${ADMIN_PASSWORD}"  # متغير بيئة
  authorizationStrategy:
    roleBased:
      roles:
        global:
          - name: "admin"
            permissions:
              - "hudson.model.Hudson.Administer"
              - "hudson.model.Hudson.Read"
              - "hudson.model.Hudson.RunScripts"
              - "hudson.model.Hudson.UploadPlugins"
              - "hudson.model.Hudson.ConfigureUpdateCenter"
          - name: "devops"
            permissions:
              - "hudson.model.Hudson.Read"
              - "hudson.model.Hudson.RunScripts"
              - "com.cloudbees.plugins.credentials.CredentialsProvider.Create"
              - "com.cloudbees.plugins.credentials.CredentialsProvider.Delete"
              - "com.cloudbees.plugins.credentials.CredentialsProvider.ManageDomains"
              - "com.cloudbees.plugins.credentials.CredentialsProvider.Update"
              - "com.cloudbees.plugins.credentials.CredentialsProvider.View"
              - "hudson.model.Item.Build"
              - "hudson.model.Item.Cancel"
              - "hudson.model.Item.Configure"
              - "hudson.model.Item.Create"
              - "hudson.model.Item.Delete"
              - "hudson.model.Item.Discover"
              - "hudson.model.Item.Read"
              - "hudson.model.Item.Workspace"
              - "hudson.model.Run.Delete"
              - "hudson.model.Run.Replay"
              - "hudson.model.Run.Update"
              - "hudson.model.View.Create"
              - "hudson.model.View.Delete"
              - "hudson.model.View.Configure"
              - "hudson.model.View.Read"
              - "hudson.slaves.Computer.Build"
              - "hudson.slaves.Computer.Configure"
              - "hudson.slaves.Computer.Create"
              - "hudson.slaves.Computer.Delete"
              - "hudson.slaves.Computer.Disconnect"
              - "hudson.slaves.Computer.Connect"
          - name: "developer"
            permissions:
              - "hudson.model.Item.Build"
              - "hudson.model.Item.Cancel"
              - "hudson.model.Item.Discover"
              - "hudson.model.Item.Read"
              - "hudson.model.Item.Workspace"
              - "hudson.model.Run.Replay"
              - "hudson.model.Run.Update"
              - "hudson.model.View.Read"
              - "hudson.slaves.Computer.Build"
          - name: "viewer"
            permissions:
              - "hudson.model.Hudson.Read"
              - "hudson.model.Item.Discover"
              - "hudson.model.Item.Read"
              - "hudson.model.Run.Read"
              - "hudson.model.View.Read"
      roleAssignments:
        global:
          - role: "admin"
            groups: ["admin-group"]
          - role: "devops"
            groups: ["devops-group"]
          - role: "developer"
            groups: ["dev-group"]
          - role: "viewer"
            groups: ["viewer-group"]

credentials:
  system:
    domainCredentials:
      - credentials:
          - string:
              scope: GLOBAL
              id: "github-pat"
              description: "GitHub PAT for Jenkins"
              secret: "${GITHUB_PAT}"
          - string:
              scope: GLOBAL
              id: "sonarqube-token"
              description: "SonarQube Analysis Token"
              secret: "${SONARQUBE_TOKEN}"
          - usernamePassword:
              scope: GLOBAL
              id: "docker-registry-creds"
              description: "Docker Registry Credentials"
              username: "${DOCKER_REGISTRY_USER}"
              password: "${DOCKER_REGISTRY_PASS}"
          - sshUserPrivateKey:
              scope: GLOBAL
              id: "ssh-agent-key"
              description: "SSH Key for Build Agents"
              username: "jenkins"
              privateKeySource:
                directEntry:
                  privateKey: "${SSH_PRIVATE_KEY}"
          - usernamePassword:
              scope: GLOBAL
              id: "smtp-credentials"
              description: "SMTP Credentials for Email"
              username: "${SMTP_USER}"
              password: "${SMTP_PASS}"

tool:
  git:
    installations:
      - name: "Default"
        home: "/usr/bin/git"
  maven:
    installations:
      - name: "Maven-3.9"
        properties:
          - installSource:
              installers:
                - mavenCentral:
                    id: "3.9.6"
  jdk:
    installations:
      - name: "JDK-21"
        properties:
          - installSource:
              installers:
                - adoptium:
                    id: "jdk-21.0.3+9"
                    jvmVariants: ["hotspot"]

nodes:
  - permanent:
      name: "docker-agent"
      remoteFS: "/home/jenkins/agent"
      labels: "docker-agent ansible-agent"
      launcher:
        ssh:
          host: "${AGENT_HOST}"
          port: 22
          credentialsId: "ssh-agent-key"
          hostKeyVerificationStrategy:
            knownHostsFile: {}
      retentionStrategy:
        always: {}
```

---

### متغيرات البيئة (Environment Variables)

في `docker-compose.yml` لخدمة Jenkins، أضف:

```yaml
services:
  jenkins:
    environment:
      - CASC_JENKINS_CONFIG=/var/jenkins_home/casc/jenkins.yaml
      - ADMIN_PASSWORD=${ADMIN_PASSWORD}
      - GITHUB_PAT=${GITHUB_PAT}
      - SONARQUBE_TOKEN=${SONARQUBE_TOKEN}
      - DOCKER_REGISTRY_USER=${DOCKER_REGISTRY_USER}
      - DOCKER_REGISTRY_PASS=${DOCKER_REGISTRY_PASS}
      - SSH_PRIVATE_KEY=${SSH_PRIVATE_KEY}
      - SMTP_USER=${SMTP_USER}
      - SMTP_PASS=${SMTP_PASS}
      - AGENT_HOST=${AGENT_HOST}
    volumes:
      - jenkins_home:/var/jenkins_home
      - ./casc:/var/jenkins_home/casc:ro  # ملف jenkins.yaml للقراءة فقط
```

> **ملف `.env` المحلي** (لا يُضاف لـ Git):
> ```bash
> ADMIN_PASSWORD=StrongAdminPass123!
> GITHUB_PAT=ghp_xxxxxxxxxxxx
> SONARQUBE_TOKEN=sqp_xxxxxxxxxxxx
> DOCKER_REGISTRY_USER=myuser
> DOCKER_REGISTRY_PASS=dockerpat123
> SSH_PRIVATE_KEY="-----BEGIN OPENSSH PRIVATE KEY-----\n..."
> SMTP_USER=jenkins@company.com
> SMTP_PASS=apppassword123
> AGENT_HOST=10.0.1.50
> ```

---

### إعادة تحميل التكوين بأمان (Safe Reload)

1. بعد تعديل `jenkins.yaml`، اذهب إلى **Manage Jenkins → Configuration as Code**.
2. انقر **Reload existing configuration**.
3. راقب السجلات: `docker logs -f jenkins | grep -i casc`.
4. إذا فشل التحميل، Jenkins يحتفظ بالتكوين السابق يعمل — لا يحدث انقطاع.

> **أفضل ممارسة:** اختبر تغييرات JCasC في بيئة تطوير/Staging قبل الإنتاج. استخدم `jenkins-configuration-as-code` validator محليًا:
> ```bash
> docker run --rm -v $(pwd)/casc:/casc jenkins/jenkins:lts-jdk21 /bin/bash -c "CASC_JENKINS_CONFIG=/casc/jenkins.yaml /usr/local/bin/jenkins-plugin-cli --validate /casc/jenkins.yaml"
> ```

---

### قاعدة ذهبية: لا أسرار في Git

| المسموح في Git (jenkins.yaml) | **ممنوع** في Git |
|-------------------------------|------------------|
| مراجع متغيرات بيئة: `${SECRET}` | قيم حقيقية: `password: "mypass123"` |
| معرفات Credentials IDs: `credentialsId: "github-pat"` | توكنات: `secret: "ghp_xxx"` |
| مسارات، منافذ، تسميات | مفاتيح SSH خاصة، كلمات مرور، App Passwords |
| هيكل التكوين، الأدوار، الصلاحيات | أي سر قابل للاستغلال |

---

## 9. التقارير ونتائج الاختبارات (Reports & Test Results)

الإضافات ذات الصلة: `junit`، `htmlpublisher`، `coverage`، `warnings-ng`، `build-timeout`، `timestamper`.

### أ. تقارير JUnit (JUnit Plugin)

**الوظيفة:** تحليل ملفات XML نتائج الاختبار (JUnit، TestNG، pytest-junit، pytest-xml، إلخ) وعرض رسوم بيانية للاتجاهات.

**التكوين في Pipeline:**

```groovy
pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
                sh 'pytest --junitxml=test-results.xml'
            }
            post {
                always {
                    junit 'test-results.xml'
                }
            }
        }
    }
}
```

**المتطلبات:** ملف XML متوافق مع مخطط JUnit. `pytest` يحتاج `pytest-junitxml` أو `--junitxml`.

> **محل صورة توضيحية:** `screenshots/17-junit-trend.png` — رسم بياني لاتجاه نجاح/فشل الاختبارات عبر البناءات.

---

### ب. ناشر HTML (HTML Publisher Plugin)

**الوظيفة:** نشر تقارير HTML ثابتة (تغطية الكود، توثيق، تقارير مخصصة) كأرشيفات قابلة للتصفح من صفحة البناء.

**التكوين في Pipeline:**

```groovy
pipeline {
    agent any
    stages {
        stage('Coverage Report') {
            steps {
                sh 'pytest --cov=src --cov-report=html:coverage-html'
            }
        }
    }
    post {
        always {
            publishHTML([
                allowMissing: false,
                alwaysLinkToLastBuild: true,
                keepAll: true,
                reportDir: 'coverage-html',
                reportFiles: 'index.html',
                reportName: 'Coverage Report',
                reportTitles: 'Coverage Report'
            ])
        }
    }
}
```

**النتيجة:** رابط "Coverage Report" في القائمة الجانبية لصفحة البناء.

> **محل صورة توضيحية:** `screenshots/18-html-publisher-link.png` — رابط التقرير المنشور في صفحة البناء.

---

### ج. تغطية الكود (Coverage Plugin)

**الوظيفة:** عرض مقاييس التغطية (Line، Branch، Method) من ملفات Cobertura، JaCoCo، OpenCover، lcov، إلخ.

**التكوين في Pipeline:**

```groovy
pipeline {
    agent any
    stages {
        stage('Test with Coverage') {
            steps {
                sh '''
                    pip install pytest-cov
                    pytest --cov=src --cov-report=xml:coverage.xml
                '''
            }
        }
    }
    post {
        always {
            coverage adapters: [coberturaAdapter('coverage.xml')], sourceDir: 'src'
        }
    }
}
```

**المقاييس المعروضة:** Line Coverage %، Branch Coverage %، مع تفصيل لكل ملف/فئة.

> **محل صورة توضيحية:** `screenshots/19-coverage-dashboard.png` — لوحة معلومات التغطية مع النسب المئوية.

---

### د. تحذيرات الجيل القادم (Warnings Next Generation Plugin)

**الوظيفة:** تحليل مخرجات المترجمات، أدوات الفحص الثابت (linters)، وأدوات التحليل الثابت (SpotBugs، SonarQube، ESLint، pylint، bandit، إلخ) وعرض تحذيرات موحدة مع اتجاهات.

**التكوين في Pipeline:**

```groovy
pipeline {
    agent any
    stages {
        stage('Static Analysis') {
            steps {
                sh '''
                    pip install pylint bandit
                    pylint --output-format=text src/ > pylint-report.txt || true
                    bandit -r src/ -f txt -o bandit-report.txt || true
                '''
            }
        }
    }
    post {
        always {
            recordIssues tools: [
                patternBased(pattern: '\\[(.+)\\]\\((.+)\\)', regex: true),  // pylint format
                // أو استخدم الأدوات المدمجة:
                // pyLint(pattern: 'pylint-report.txt'),
                // bandit(pattern: 'bandit-report.txt'),
            ]
        }
    }
}
```

**الأدوات المدعومة مدمجًا:** GCC، Clang، MSBuild، javac، Kotlin، pylint، flake8، ESLint، SpotBugs، SonarQube، Checkstyle، PMD، FindBugs، وغيرها الكثير.

> **محل صورة توضيحية:** `screenshots/20-warnings-ng-trend.png` — اتجاه التحذيرات (جديدة، ثابتة، مُصلحة) عبر البناءات.

---

### هـ. مهلة البناء (Build Timeout Plugin)

**الوظيفة:** إنهاء البناء تلقائيًا إذا تجاوز مدة محددة، مع دعم مهلة لكل مرحلة.

**التكوين في Pipeline:**

```groovy
pipeline {
    agent any
    options {
        timeout(time: 60, unit: 'MINUTES')  // مهلة عامة للبناء كاملاً
    }
    stages {
        stage('Long Running') {
            options {
                timeout(time: 10, unit: 'MINUTES')  // مهلة لهذه المرحلة فقط
            }
            steps {
                sh 'sleep 300'  // سيُنهى بعد 10 دقائق
            }
        }
    }
}
```

**السلوك:** عند انتهاء المهلة، يُعلَّم البناء `ABORTED` وتظهر رسالة "Build timed out".

---

### و. الطوابع الزمنية (Timestamper Plugin)

**الوظيفة:** إضافة طوابع زمنية لسجل وحدة التحكم (Console Output) لتسهيل تحليل الأداء وتسلسل الأحداث.

**التكوين:**
- **عالمي:** Manage Jenkins → Configure System → Timestamper → اختر تنسيق (مثل `HH:mm:ss` أو `ISO 8601`).
- **في Pipeline:** أضف `timestamps()` في `options` أو غلف الخطوات:

```groovy
pipeline {
    agent any
    options {
        timestamps()  // يطبق على كل البناء
    }
    stages {
        stage('Build') {
            steps {
                timestamps {  // أو على مرحلة محددة
                    sh 'echo "Start"; sleep 2; echo "End"'
                }
            }
        }
    }
}
```

**الناتج في Console:**
```
14:32:15  Start
14:32:17  End
```

---

## قائمة التحقق النهائية (Verification Checklist)

بعد إكمال المرحلتين أ و ب، تأكد من العناصر التالية قبل الانتقال للمرحلة 3 (CI/CD):

### المرحلة أ — التثبيت
- [ ] جميع إضافات `plugins.txt` (24 إضافة) تظهر في **Installed plugins**.
- [ ] لا توجد أخطاء `ERROR` أو `FAILED` في `docker logs jenkins` تتعلق بالإضافات.
- [ ] `docker compose ps` يُظهر `jenkins` بحالة `Up (healthy)`.
- [ ] `docker exec jenkins ls /var/jenkins_home/plugins/` يُظهر ملفات `.jpi`/`.hpi` للإضافات.
- [ ] Jenkins أُعيد تشغيله مرة واحدة على الأقل بعد التثبيت.

### المرحلة ب — التكامل
| التكامل | اختبار اجتياز مطلوب | توثيق في |
|----------|---------------------|-----------|
| GitHub | Multibranch Pipeline يفحص المستودع ويكتشف الفروع | `02-Integration/github/TEST_REPORT.md` |
| Docker | بناء صورة Docker ودفعها لمستودع تجريبي على وكيل معزول | `02-Integration/docker/TEST_REPORT.md` |
| Ansible | Playbook تجريبي يعمل بنجاح (check mode أو staging) | `02-Integration/ansible/TEST_REPORT.md` |
| SonarQube | مسح مشروع نموذجي يظهر في SonarQube UI | `02-Integration/sonarqube/TEST_REPORT.md` |
| SSH Agents | وكيل بعيد متصل (Online) وينفذ مهمة اختبار | `02-Integration/ssh-agents/TEST_REPORT.md` |
| Email | بريد تجريبي مستلم عبر SMTP | `02-Integration/email/TEST_REPORT.md` |
| Role Strategy | أربعة أدوار منشأة ومُعينون لمستخدمين اختبار | `02-Integration/roles/TEST_REPORT.md` |
| JCasC | `jenkins.yaml` يُحمّل بنجاح، إعادة تحميل آمنة تعمل | `02-Integration/jcasc/TEST_REPORT.md` |
| Reports | JUnit، HTML، Coverage، Warnings تظهر في بناء تجريبي | `02-Integration/reports/TEST_REPORT.md` |

> **قاعدة:** لا تبدأ **المرحلة 3 (CI/CD)** إلا بعد أن تكون جميع تقارير `TEST_REPORT.md` أعلاه مكتملة بنتائج **فعلية** (أوامر ومخرجات موثقة).

---

## المراجع الرسمية

- **Jenkins Plugin Installation Manager:** https://github.com/jenkinsci/plugin-installation-manager-tool
- **Jenkins Update Center (Plugin IDs):** https://plugins.jenkins.io/
- **Official Jenkins Docker Image:** https://hub.docker.com/r/jenkins/jenkins
- **Jenkins Docker Installation Guide:** https://www.jenkins.io/doc/book/installing/docker/
- **Configuration as Code Plugin:** https://plugins.jenkins.io/configuration-as-code/
- **Role-based Authorization Strategy:** https://plugins.jenkins.io/role-strategy/
- **Docker Pipeline Plugin:** https://plugins.jenkins.io/docker-workflow/
- **GitHub Branch Source Plugin:** https://plugins.jenkins.io/github-branch-source/
- **SonarQube Scanner for Jenkins:** https://plugins.jenkins.io/sonar/
- **Warnings Next Generation:** https://plugins.jenkins.io/warnings-ng/
- **HTML Publisher:** https://plugins.jenkins.io/htmlpublisher/
- **Coverage Plugin:** https://plugins.jenkins.io/coverage/
- **Email Extension:** https://plugins.jenkins.io/email-ext/
- **SSH Build Agents:** https://plugins.jenkins.io/ssh-slaves/
- **JUnit Plugin:** https://plugins.jenkins.io/junit/
- **Build Timeout:** https://plugins.jenkins.io/build-timeout/
- **Timestamper:** https://plugins.jenkins.io/timestamper/
- **Credentials Binding:** https://plugins.jenkins.io/credentials-binding/
- **SSH Agent:** https://plugins.jenkins.io/ssh-agent/
- **Workspace Cleanup:** https://plugins.jenkins.io/ws-cleanup/
- **CloudBees Folders:** https://plugins.jenkins.io/cloudbees-folder/
- **Ansible Plugin:** https://plugins.jenkins.io/ansible/
- **Pipeline (workflow-aggregator):** https://plugins.jenkins.io/workflow-aggregator/

---

## ملاحق

### أ. قائمة `plugins.txt` الكاملة (للنسخ السريع)

```text
git
github
github-branch-source
workflow-aggregator
credentials-binding
ssh-agent
ws-cleanup
timestamper
build-timeout
docker-workflow
ansible
ssh-slaves
sonar
warnings-ng
junit
htmlpublisher
coverage
email-ext
role-strategy
cloudbees-folder
configuration-as-code
```

### ب. هيكل المجلدات المتوقع للتقارير

```
02-Integration/
├── github/
│   ├── README.md
│   └── TEST_REPORT.md
├── docker/
│   ├── README.md
│   └── TEST_REPORT.md
├── ansible/
│   ├── README.md
│   └── TEST_REPORT.md
├── sonarqube/
│   ├── README.md
│   └── TEST_REPORT.md
├── ssh-agents/
│   ├── README.md
│   └── TEST_REPORT.md
├── email/
│   ├── README.md
│   └── TEST_REPORT.md
├── roles/
│   ├── README.md
│   └── TEST_REPORT.md
├── jcasc/
│   ├── README.md
│   └── TEST_REPORT.md
├── reports/
│   ├── README.md
│   └── TEST_REPORT.md
└── traefik/
    ├── README.md
    └── TEST_REPORT.md
```

---

**تاريخ الإنشاء:** 2026-11-12  
**الإصدار:** 1.0  
**المسؤول:** فريق DevOps  
**حالة الوثيقة:** جاهزة للمراجعة والتنفيذ

> **ملاحظة أخيرة:** هذا الدليل وثيقة حية. حدّثه عند كل تغيير في الإضافات، الإصدارات، أو إجراءات التكامل. اربط كل تغيير بـ Commit message واضح وحدث `INSTALLATION_REPORT.md` و `TEST_REPORT.md` ذات الصلة.