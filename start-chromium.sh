#!/bin/sh
set -e

echo "=== Chromium CDP Service Starting ==="

# Kill any existing processes
pkill -f chromium-browser || true
sleep 2

echo "Starting Chromium on 0.0.0.0:9222..."

# Start Chromium directly on external interface
exec /usr/bin/chromium-browser \
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
  --remote-debugging-address=0.0.0.0 \
  --remote-debugging-port=9222 \
  --remote-allow-origins=* \
  --user-data-dir=/tmp/chromium-data \
  about:blank
