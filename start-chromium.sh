#!/bin/sh
set -e

echo "=== Chromium CDP Service Starting ==="

# Kill any existing Chromium/socat processes (cleanup from previous crashes)
pkill -f chromium-browser || true
pkill -f socat || true

# Wait for cleanup
sleep 1

echo "Starting Chromium in background on 127.0.0.1:9222..."

# Start Chromium in background
/usr/bin/chromium-browser \
  --headless=new \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-gpu-compositing \
  --disable-gpu-rasterization \
  --disable-gpu-sandbox \
  --disable-software-rasterizer \
  --disable-vulkan \
  --disable-features=VizDisplayCompositor,Vulkan \
  --use-gl=swiftshader-webgl \
  --disable-extensions \
  --disable-background-networking \
  --disable-background-timer-throttling \
  --disable-backgrounding-occluded-windows \
  --disable-breakpad \
  --disable-component-extensions-with-background-pages \
  --disable-features=TranslateUI \
  --disable-ipc-flooding-protection \
  --disable-renderer-backgrounding \
  --enable-features=NetworkService,NetworkServiceInProcess \
  --force-color-profile=srgb \
  --hide-scrollbars \
  --metrics-recording-only \
  --mute-audio \
  --no-first-run \
  --remote-debugging-address=127.0.0.1 \
  --remote-debugging-port=9222 \
  --user-data-dir=/tmp/chromium-data \
  about:blank > /tmp/chromium.log 2>&1 &

CHROMIUM_PID=$!
echo "Chromium started with PID: $CHROMIUM_PID"

# Wait for Chromium to be ready (check /json endpoint)
echo "Waiting for Chromium to be ready..."
for i in $(seq 1 30); do
  if curl -s http://127.0.0.1:9222/json/version > /dev/null 2>&1; then
    echo "✓ Chromium is ready!"
    break
  fi
  echo "  Waiting... ($i/30)"
  sleep 1
done

# Verify Chromium is actually running
if ! curl -s http://127.0.0.1:9222/json/version > /dev/null 2>&1; then
  echo "ERROR: Chromium failed to start"
  cat /tmp/chromium.log
  exit 1
fi

echo "Starting socat proxy: 0.0.0.0:9222 -> 127.0.0.1:9222"

# Start socat in foreground (keeps container alive)
exec socat TCP-LISTEN:9222,bind=0.0.0.0,fork,reuseaddr TCP:127.0.0.1:9222
