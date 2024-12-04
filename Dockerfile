FROM node:20.18.0 AS base

WORKDIR /app

# pnpm'i etkinleştir
RUN corepack enable pnpm

# Bağımlılıkları yükle
COPY package.json pnpm-lock.yaml ./
RUN pnpm install

# Kaynak kodları kopyala
COPY . .

# Build işlemi
RUN pnpm run build

# Wrangler ayarları
RUN mkdir -p /root/.config/.wrangler && \
    echo '{"enabled":false}' > /root/.config/.wrangler/metrics.json && \
    chmod -R 755 /root/.config/.wrangler

# Port ayarı
EXPOSE 5173

# Environment variables
ENV NODE_ENV=development \
    WRANGLER_SEND_METRICS=false \
    HOST=0.0.0.0

# Başlatma komutu
CMD ["pnpm", "run", "preview"]