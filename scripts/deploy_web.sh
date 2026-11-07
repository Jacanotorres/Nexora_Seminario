#!/usr/bin/env bash
# Compila Flutter web y despliega build/web en Vercel.
# Requiere .env.local con SUPABASE_URL y SUPABASE_ANON_KEY, y `vercel login` hecho.
set -euo pipefail
cd "$(dirname "$0")/.."

set -a
. ./.env.local
set +a

flutter build web --release \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"

cp web_deploy/vercel.json build/web/vercel.json
cd build/web
vercel deploy --prod "$@"
