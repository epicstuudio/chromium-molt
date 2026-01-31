#!/bin/sh
set -e

echo "Starting Chromium headless with CDP on port 9222..."

# Launch Chromium in headless mode with remote debugging
exec /usr/bin/chromium-browser \
  --headless=new \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --disable-software-rasterizer \
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
  --user-data-dir=/tmp/chromium-data \
  about:blank
