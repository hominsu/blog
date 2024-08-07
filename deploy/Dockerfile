FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Install dependencies based on the preferred package manager
COPY package.json .yarnrc.yml* yarn.lock* ./
COPY .yarn/ ./.yarn/
RUN yarn --frozen-lockfile
RUN npm install -g --platform=linux --libc=glibc sharp


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
    yarn build


# Production image, copy all the files and run next
FROM base AS runner

# image info
ARG AUTHOR_NAME
ARG AUTHOR_EMAIL
ARG VERSION

# label
LABEL author=${AUTHOR_NAME} email=${AUTHOR_EMAIL} version=${VERSION}

WORKDIR /app

ENV NODE_ENV production
ENV NEXT_TELEMETRY_DISABLED 1
ENV NEXT_SHARP_PATH=/usr/local/lib/node_modules/sharp

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=deps --chown=nextjs:nodejs /usr/local/lib/node_modules/sharp /usr/local/lib/node_modules/sharp
COPY --from=builder /app/public ./public

# Set the correct permission for prerender cache
RUN mkdir .next
RUN chown nextjs:nodejs .next

# Automatically leverage output traces to reduce image size
# https://nextjs.org/docs/advanced-features/output-file-tracing
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

# server.js is created by next build from the standalone output
# https://nextjs.org/docs/pages/api-reference/next-config-js/output
CMD ["node", "server.js"]
