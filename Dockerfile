# Dockerfile

# =================================================================
# ETAPA 1: BUILDER (Instalación de dependencias y Ejecución de Pruebas)
# =================================================================
FROM node:20 AS builder
WORKDIR /app

# Copia los archivos de configuración
COPY package*.json ./

# Instala todas las dependencias (incluyendo devDependencies para Jest)
# Las advertencias de npm se ignoran para el pipeline, pero se muestran.
RUN npm install

# Copia el resto del código
COPY . .

# 🛑 ¡Punto de Fallo del CI! Ejecuta las pruebas. Si fallan, el Docker build falla.
RUN npm test

# =================================================================
# ETAPA 2: PRODUCTION (Imagen final y ligera)
# =================================================================
FROM node:20-alpine
WORKDIR /app

# Copia SÓLO las dependencias que ya se instalaron y el código de la aplicación.
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/index.js ./index.js
COPY --from=builder /app/package.json ./package.json

# Puerto por defecto de Express
EXPOSE 3000

# Comando para iniciar la aplicación en producción
CMD ["npm", "start"]