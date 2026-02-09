# Stage 1: Build & Test
FROM node:18.15.0-alpine AS builder
WORKDIR /app
COPY package*.json ./
# Instalamos todas las dependencias
RUN npm install
COPY . .
# Ejecutamos tests según el README
RUN npm run test

# Stage 2: Production
FROM node:18.15.0-alpine
LABEL maintainer="Candidato DevOps"
ENV NODE_ENV=production
ENV PORT=8000

WORKDIR /app

# Seguridad: Crear usuario no-root
RUN addgroup -S devsu && adduser -S devsu -G devsu

# Copiar solo lo necesario para ejecución
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/shared ./shared
COPY --from=builder /app/users ./users
COPY --from=builder /app/index.js ./

# Permisos para SQLite (mencionado en README)
RUN touch dev.sqlite && chown devsu:devsu dev.sqlite /app

USER devsu
EXPOSE 8000

# Healthcheck: Validamos que el endpoint base responda
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:8000/api/users', (res) => res.statusCode === 200 ? process.exit(0) : process.exit(1))"

CMD ["npm", "start"]