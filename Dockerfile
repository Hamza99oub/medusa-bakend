FROM node:20-alpine

RUN npm install -g npm@11.13.0 turbo

WORKDIR /app

COPY package.json package-lock.json* ./
COPY apps/backend/package.json ./apps/backend/package.json

RUN npm ci

COPY turbo.json ./
COPY apps/backend ./apps/backend

RUN npm run build -- --filter=@dtc/backend

RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 medusa

USER medusa

EXPOSE 9000

ENV NODE_ENV=production

WORKDIR /app/apps/backend

CMD /app/node_modules/.bin/medusa start
