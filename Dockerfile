FROM node:18-alpine

# Install Chromium, nginx, and dependencies
RUN apk add --no-cache \
    chromium \
    nginx \
    nss \
    freetype \
    harfbuzz \
    ca-certificates \
    ttf-freefont \
    dumb-init

# Set environment variables
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser \
    CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/bin/chromium-browser \
    PUPPETEER_DISABLE_DEV_SHM_USAGE=true

# Create non-root user
RUN addgroup -g 1001 chromium && \
    adduser -D -u 1001 -G chromium chromium && \
    mkdir -p /home/chromium/Downloads /app /run/nginx && \
    chown -R chromium:chromium /home/chromium /app && \
    chown -R chromium:chromium /var/lib/nginx /var/log/nginx /run/nginx

# Create nginx config
COPY nginx.conf /etc/nginx/nginx.conf
COPY start-chromium.sh /start.sh
RUN chmod +x /start.sh && chown chromium:chromium /start.sh

USER chromium
WORKDIR /app

EXPOSE 9222

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/start.sh"]
