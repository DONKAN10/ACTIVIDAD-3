# Dockerfile

# =================================================================
# ETAPA 1: BUILDER (Instalación, Pruebas)
# =================================================================
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./

# ** SOLUCIÓN FINAL 2 **: Usamos npm ci (Clean Install) para asegurar una instalación
# determinista, limpia y más confiable, lo cual debería resolver los problemas de
# dependencias faltantes como jest-circus después de los scripts postinstall.
# Mantenemos --unsafe-perm como contingencia.
RUN npm ci --unsafe-perm && npm cache clean --force

COPY . .

# Mantenemos chmod +x para asegurar permisos de ejecución en todos los binarios de scripts.
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