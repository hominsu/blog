FROM node:20-alpine AS base

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs


# Install dependencies only when needed
FROM base AS deps

WORKDIR /app
COPY package.json ./

RUN corepack enable && \
    corepack use pnpm && \
    pnpm i && \
    mkdir -p /sharp && \
    pnpm add sharp --prefix /sharp


# Rebuild the source code only when needed
FROM base AS builder

WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ENV NEXT_TELEMETRY_DISABLED 1
RUN --mount=type=secret,id=NEXT_PUBLIC_ALGOLIA_APIKEY \
    --mount=type=secret,id=NEXT_PUBLIC_ALGOLIA_APPID \
    --mount=type=secret,id=NEXT_PUBLIC_ALGOLIA_INDEX_NAME \
    --mount=type=secret,id=NEXT_PUBLIC_GISCUS_CATEGORY \
    --mount=type=secret,id=NEXT_PUBLIC_GISCUS_CATEGORY_ID \
    --mount=type=secret,id=NEXT_PUBLIC_GISCUS_REPO \
    --mount=type=secret,id=NEXT_PUBLIC_GISCUS_REPOSITORY_ID \
    NEXT_PUBLIC_ALGOLIA_APIKEY=$(cat /run/secrets/NEXT_PUBLIC_ALGOLIA_APIKEY) \
    NEXT_PUBLIC_ALGOLIA_APPID=$(cat /run/secrets/NEXT_PUBLIC_ALGOLIA_APPID) \
    NEXT_PUBLIC_ALGOLIA_INDEX_NAME=$(cat /run/secrets/NEXT_PUBLIC_ALGOLIA_INDEX_NAME) \
    NEXT_PUBLIC_GISCUS_CATEGORY=$(cat /run/secrets/NEXT_PUBLIC_GISCUS_CATEGORY) \
    NEXT_PUBLIC_GISCUS_CATEGORY_ID=$(cat /run/secrets/NEXT_PUBLIC_GISCUS_CATEGORY_ID) \
    NEXT_PUBLIC_GISCUS_REPO=$(cat /run/secrets/NEXT_PUBLIC_GISCUS_REPO) \
    NEXT_PUBLIC_GISCUS_REPOSITORY_ID=$(cat /run/secrets/NEXT_PUBLIC_GISCUS_REPOSITORY_ID) \
    npm run build


FROM scratch AS export

COPY --from=builder /app/public /app/public
COPY --from=builder /app/.next/standalone /app/
COPY --from=builder /app/.next/static /app/.next/static
COPY --from=deps /sharp/node_modules/.pnpm /app/node_modules/.pnpm


# Production image, copy all the files and run next
FROM base AS runner

WORKDIR /app

COPY --from=export --chown=nextjs:nodejs /app /app

ENV NODE_ENV="production" \
    NEXT_TELEMETRY_DISABLED=1

ENV HOSTNAME="0.0.0.0" \
    PORT="3000"

USER nextjs

EXPOSE 3000/tcp

# server.js is created by next build from the standalone output
# https://nextjs.org/docs/pages/api-reference/next-config-js/output
CMD ["node", "/app/server.js"]
