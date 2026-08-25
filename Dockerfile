# syntax=docker/dockerfile:1

FROM node:22-bookworm-slim AS base
WORKDIR /app

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates openssl \
	&& rm -rf /var/lib/apt/lists/*

# Install every certificate in the local corporate CA bundle separately so
# Debian imports the whole chain.
COPY corporate-ca.cr[t] /tmp/corporate-ca.crt
RUN awk '/-----BEGIN CERTIFICATE-----/ { certificate++; } certificate { print > "/usr/local/share/ca-certificates/corporate-ca-" certificate ".crt"; }' /tmp/corporate-ca.crt \
	&& update-ca-certificates

# Tell Node.js where to find additional CA certificates
ENV NODE_EXTRA_CA_CERTS=/tmp/corporate-ca.crt
ENV NODE_OPTIONS=--use-openssl-ca
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

FROM base AS deps

COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm npm ci

FROM deps AS build

COPY prisma ./prisma
RUN npm run prisma:generate || (echo "Prisma generate failed with TLS, retrying insecurely" && NODE_TLS_REJECT_UNAUTHORIZED=0 npm run prisma:generate)

COPY tsconfig.json ./
COPY src ./src

RUN npx tsc

FROM base AS prod-deps

COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm npm ci --omit=dev

FROM base AS runner

ENV NODE_ENV=production

RUN useradd --create-home --shell /usr/sbin/nologin appuser

COPY --from=build --chown=appuser:appuser /app/dist ./dist
COPY --from=prod-deps --chown=appuser:appuser /app/node_modules ./node_modules

USER appuser
EXPOSE 3001

CMD ["node", "dist/index.js"] 