# Phase 1 preflight (Windows host) — run from 01-Installation on target Ubuntu for full checks
$ErrorActionPreference = 'Continue'
Write-Output "=== OS ==="; systeminfo | Select-String 'OS Name|OS Version|System Type' | Select-Object -First 5
Write-Output "`n=== Docker/Compose ==="; docker --version 2>&1; docker compose version 2>&1
Write-Output "`n=== Existing Jenkins containers/volumes (if Docker available) ==="; docker ps -a --format '{{.Names}} {{.Image}} {{.Status}}' 2>&1 | Select-String -Pattern 'jenkins' ; docker volume ls 2>&1 | Select-String -Pattern 'jenkins'
Write-Output "`n=== Listen ports 8080,50000,80,443 ==="; Get-NetTCPConnection -State Listen -ErrorAction SilentlyContinue | Where-Object { $_.LocalPort -in 8080,50000,80,443 } | Select-Object LocalAddress,LocalPort,OwningProcess | Format-Table -AutoSize
Write-Output "`n=== Docker networks (if available) ==="; docker network ls 2>&1 | Select-Object -First 15