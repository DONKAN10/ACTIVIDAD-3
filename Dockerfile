# Dockerfile

# ===================================================================
# STAGE 1: BUILDER - Instalación de dependencias (para npm ci)
# Usamos una imagen completa si necesitamos herramientas de compilación,
# pero para solo Express/Jest, node:20 funciona.
FROM node:20 AS builder

WORKDIR /app

# Copia los archivos de manifiesto clave
COPY package*.json ./

# Instala dependencias. 
# NOTA: --unsafe-perm ayuda con ciertos módulos, pero el problema real es el USER.
RUN npm ci --unsafe-perm --only=production

# ===================================================================
# STAGE 2: FINAL - Imagen de producción ligera
# Usamos la versión Alpine para una imagen mucho más pequeña
FROM node:20-alpine

# Define el directorio de trabajo
WORKDIR /app

# Copia solo las dependencias de producción del stage 'builder'
# Esto hace la imagen final muy pequeña.
COPY --from=builder /app/node_modules ./node_modules

# Copia los archivos del proyecto y el package.json (para los scripts)
COPY package*.json ./
COPY index.js .

# Define el usuario que ejecutará la aplicación (resuelve "Permission denied")
# El usuario 'node' ya existe en la imagen node-alpine
USER node

# Expone el puerto donde Express escuchará
EXPOSE 3000

# Comando para iniciar la aplicación (usa el script "start" de package.json)
CMD ["npm", "start"]