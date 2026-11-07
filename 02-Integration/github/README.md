# GitHub Integration (Phase 2 — after Phase 1 PASS)
## Prereqs
Phase 1 PASS + INSTALLATION_REPORT.md updated. Jenkins URL stable.
## Scope
Git plugin/credentials, webhook (secret), checkout + trigger test, branch/PR policy as needed.
## Safety
No tokens/passwords in Git/Jenkinsfiles; use Jenkins Credentials. Protect webhooks.
## Test (record actual results in TEST_REPORT.md)
- [ ] Credential created (type only). [ ] Test repo checkout succeeds. [ ] Webhook/scan trigger verified (if used).