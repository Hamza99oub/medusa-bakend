FROM node:20-alpine AS base

RUN npm install -g npm@11.13.0 turbo

FROM base AS builder
WORKDIR /app

COPY package.json package-lock.json* ./
COPY apps/backend/package.json ./apps/backend/package.json

RUN npm ci

COPY turbo.json ./
COPY apps/backend ./apps/backend

RUN npm run build -- --filter=@dtc/backend

FROM base AS runner
WORKDIR /app

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 medusa

COPY --from=builder /app .

USER medusa

EXPOSE 9000

ENV NODE_ENV=production

CMD ["npm", "run", "start"]
