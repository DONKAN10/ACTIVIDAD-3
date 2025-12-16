# Dockerfile

# ===================================================================
# STAGE 1: BUILDER - Instalación de dependencias (Rápido y completo)
FROM node:20 AS builder

WORKDIR /app

# Copia los archivos de manifiesto clave
COPY package*.json ./

# Instala todas las dependencias (incluyendo devDeps como jest) para poder hacer pruebas
# Si las pruebas se hacen FUERA de Docker, puedes usar --only=production
RUN npm ci --unsafe-perm

# ===================================================================
# STAGE 2: FINAL - Imagen de producción ligera (node:20-alpine)
FROM node:20-alpine

# Define el directorio de trabajo
WORKDIR /app

# Copia solo las dependencias de producción del stage 'builder'
# Esto hace la imagen final muy pequeña y segura.
COPY --from=builder /app/node_modules ./node_modules

# Copia los archivos del proyecto y el package.json (para el script start)
COPY package*.json ./
COPY index.js .

# Define el usuario que ejecutará la aplicación (Buenas prácticas de seguridad)
# El usuario 'node' ya existe en la imagen node-alpine
USER node

# Expone el puerto donde Express escuchará
EXPOSE 3000

# Comando para iniciar la aplicación (usa el script "start" de package.json)
CMD ["npm", "start"]