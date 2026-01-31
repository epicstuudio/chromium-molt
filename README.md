# Chromium Headless Service for Moltbot

Lightweight Chromium browser service running on Railway for Moltbot automation.

## What This Does

- Runs headless Chromium browser
- Exposes Chrome DevTools Protocol (CDP) on port 9222
- Allows Moltbot to take screenshots, interact with websites, and analyze pages
- **No API keys needed** - internal Railway networking only

## Files in This Repo

- `Dockerfile` - Builds Alpine Linux + Chromium container
- `start-chromium.sh` - Launches Chromium in headless mode
- `.dockerignore` - Excludes unnecessary files from Docker build
- `README.md` - This file

## Deployment on Railway

1. Go to your Railway project "Pragmatic Growth"
2. Click "+ New" → "GitHub Repo"
3. Select this repo (`chromium-molt`)
4. Railway auto-detects Dockerfile and deploys
5. Service will be available at: `chromium-molt.railway.internal:9222`

## Connect to Moltbot

Add this environment variable to your `moltbot-railway-template` service:

BROWSER_CDP_URL=ws://chromium-molt.railway.internal:9222


## Test if Working

From Moltbot service, run:

```bash
curl http://chromium-molt.railway.internal:9222/json/version
