ARG BASE=node:20.18.0
FROM ${BASE} AS base

WORKDIR /app

# pnpm'i etkinleştir ve bağımlılıkları yükle
COPY package.json pnpm-lock.yaml ./
RUN corepack enable pnpm && pnpm install

# Kaynak kodları kopyala
COPY . .

# Gerekli izinleri ayarla ve wrangler metrikleri devre dışı bırak
RUN mkdir -p /root/.config/.wrangler && \
    echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json && \
    chmod -R 755 /root/.config/.wrangler

# Sistem limitlerini ayarla
RUN echo "fs.inotify.max_user_watches=524288" >> /etc/sysctl.conf && \
    echo "fs.inotify.max_user_instances=512" >> /etc/sysctl.conf

# npm'i güncelle ve wrangler'ı yükle
RUN npm install -g npm@latest && \
    npm install -g wrangler

# Port ayarı
EXPOSE 5173

# Environment variables
ENV NODE_ENV=development \
    WRANGLER_SEND_METRICS=false \
    HOST=0.0.0.0

# Development komutu
CMD ["pnpm", "run", "dev", "--host", "0.0.0.0"]