# Dockerfile

# =================================================================
# ETAPA 1: BUILDER (Instalación, Pruebas)
# =================================================================
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./

# 💡 CORRECCIÓN 1: Instalación robusta. Limpiamos la caché si hay problemas
RUN npm install && npm cache clean --force

COPY . .

# 💡 CORRECCIÓN 2: Solución al "Permission denied" (Exit Code 127) en Jest y napi-postinstall.
# Damos permisos de ejecución a TODOS los binarios dentro de node_modules/.bin.
RUN chmod +x ./node_modules/.bin/*

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