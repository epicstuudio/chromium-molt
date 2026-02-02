#!/bin/sh
set -e

echo "=== Chromium CDP Service Starting ==="

# Kill any existing processes
pkill -f chromium-browser || true
pkill -f nginx || true
sleep 2

echo "Starting Chromium on 0.0.0.0:9223..."

# Start Chromium on all interfaces so nginx can proxy it
/usr/bin/chromium-browser \
  --headless=new \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-software-rasterizer \
  --disable-extensions \
  --remote-debugging-address=0.0.0.0 \
  --remote-debugging-port=9223 \
  --remote-allow-origins=* \
  --user-data-dir=/tmp/chromium-data \
  about:blank > /tmp/chromium.log 2>&1 &

CHROMIUM_PID=$!
echo "Chromium started with PID: $CHROMIUM_PID"

# Wait for Chromium
sleep 5

if ! kill -0 $CHROMIUM_PID 2>/dev/null; then
  echo "ERROR: Chromium died"
  cat /tmp/chromium.log
  exit 1
fi

echo "✓ Chromium running"
echo "Starting nginx proxy on 0.0.0.0:9222 -> 127.0.0.1:9223"

# Start nginx in foreground
exec nginx -g 'daemon off;'
