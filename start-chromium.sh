#!/bin/sh
set -e

echo "=== Chromium CDP Service Starting ==="

# Kill any existing processes
pkill -f chromium-browser || true
pkill -f socat || true
sleep 2

echo "Starting Chromium on 127.0.0.1:9223 (internal port)..."

# Start Chromium on port 9223
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
  --remote-debugging-port=9223 \
  --remote-allow-origins=* \
  --user-data-dir=/tmp/chromium-data \
  about:blank > /tmp/chromium.log 2>&1 &

CHROMIUM_PID=$!
echo "Chromium started with PID: $CHROMIUM_PID on port 9223"

# Wait for Chromium to initialize
echo "Waiting for Chromium to be ready..."
sleep 5

# Verify process is alive
if ! kill -0 $CHROMIUM_PID 2>/dev/null; then
  echo "ERROR: Chromium process died"
  cat /tmp/chromium.log
  exit 1
fi

echo "✓ Chromium process is running (PID: $CHROMIUM_PID)"
echo "Starting socat proxy: 0.0.0.0:9222 -> 127.0.0.1:9223"

# Forward external port 9222 to Chromium's port 9223
exec socat TCP-LISTEN:9222,bind=0.0.0.0,fork,reuseaddr TCP:127.0.0.1:9223
