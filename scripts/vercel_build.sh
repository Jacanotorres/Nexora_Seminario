#!/usr/bin/env bash
# Build de Flutter web para Vercel (el entorno de Vercel no trae Flutter).
# Requiere las variables SUPABASE_URL y SUPABASE_ANON_KEY en el proyecto de Vercel.
set -euo pipefail

: "${SUPABASE_URL:?Falta SUPABASE_URL en las variables de entorno de Vercel}"
: "${SUPABASE_ANON_KEY:?Falta SUPABASE_ANON_KEY en las variables de entorno de Vercel}"

if [ ! -d "$HOME/flutter" ]; then
  git clone --depth 1 --branch stable https://github.com/flutter/flutter.git "$HOME/flutter"
fi
export PATH="$HOME/flutter/bin:$PATH"

flutter config --no-analytics --enable-web
flutter pub get
flutter build web --release \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY"
