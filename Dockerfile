FROM node:18-alpine

# Install Chromium, socat, and dependencies
RUN apk add --no-cache \
    chromium \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    dumb-init \
    socat

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/bin/chromium-browser \
    PUPPETEER_DISABLE_DEV_SHM_USAGE=true

# Create non-root user (security best practice)
RUN addgroup -g 1001 chromium && \
    adduser -D -u 1001 -G chromium chromium && \
    mkdir -p /home/chromium/Downloads /app && \
    chown -R chromium:chromium /home/chromium /app

# Create startup script
COPY start-chromium.sh /start.sh
RUN chmod +x /start.sh && chown chromium:chromium /start.sh

USER chromium
WORKDIR /app

EXPOSE 9222

# Use dumb-init for proper signal handling
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/start.sh"]
