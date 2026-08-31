FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --omit=dev

COPY server.js ./
COPY test.js ./

RUN mkdir -p /var/log/app && chown -R node:node /app /var/log/app

USER node

ENV PORT=3000
ENV LOG_FILE=/var/log/app/app.log

EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

CMD ["node", "server.js"]
