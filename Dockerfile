# Dockerfile (VERSION CORREGIDA)

# =================================================================
# ETAPA 1: BUILDER (Instalación de dependencias y Ejecución de Pruebas)
# =================================================================
FROM node:20 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
# 🛑 EJECUCIÓN DE PRUEBAS EN CI
RUN ["/usr/local/bin/npm", "test"]
#
# El resto del archivo es el mismo
#
# =================================================================
# ETAPA 2: PRODUCTION (Imagen final y ligera)
# =================================================================
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/index.js ./index.js
COPY --from=builder /app/package.json ./package.json
EXPOSE 3000
CMD ["npm", "start"]