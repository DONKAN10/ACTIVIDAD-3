# Dockerfile

# =================================================================
# ETAPA 1: BUILDER
# =================================================================
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Solución al error "jest: Permission denied" (Exit Code 127)
# Forzamos permisos de ejecución en el binario de Jest.
RUN chmod +x ./node_modules/.bin/jest

# Ejecución de Pruebas (Test)
RUN ["/usr/local/bin/npm", "test"]

# =================================================================
# ETAPA 2: PRODUCTION (Imagen final ligera)
# =================================================================
FROM node:20-alpine
WORKDIR /app
# Copiamos solo los artefactos necesarios de la etapa 'builder'
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/index.js ./index.js
COPY --from=builder /app/package.json ./package.json
EXPOSE 3000
CMD ["npm", "start"]