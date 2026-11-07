#!/usr/bin/env bash
# Optional helper: clone/copy InstallingJenkins to /opt and run Phase 1 only.
# Usage on Ubuntu: sudo bash 01-Installation/scripts/deploy-to-opt.sh [TARGET_DIR]
set -euo pipefail
TARGET="${1:-/opt/InstallingJenkins}"
SRC="$(cd "$(dirname "$0")/../.." && pwd)"
echo "Source: $SRC"
echo "Target: $TARGET"
if [ -e "$TARGET" ]; then
  echo "Target exists - NOT overwriting (preserve data). Sync manually if intended: rsync -a --exclude '.env' '$SRC/' '$TARGET/'"
  exit 1
fi
mkdir -p "$(dirname "$TARGET")"
cp -a "$SRC" "$TARGET"
echo "Copied. Next:"
echo "  cd $TARGET/01-Installation"
echo "  cp .env.example .env && chmod 600 .env"
echo "  bash scripts/preflight.sh && docker compose config && docker compose up -d"