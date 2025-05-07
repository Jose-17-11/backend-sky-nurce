# Usamos multi-stage build para reducir el tamaño final
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install

FROM node:20-alpine
WORKDIR /app

# Copiar desde builder
COPY --from=builder /app/node_modules ./node_modules

# Copiar el resto de archivos
# Copiar el resto de archivos
COPY src ./src
COPY scripts-sql ./scripts-sql
COPY .env ./
COPY wait-for-it.sh ./

# Permisos y salud del contenedor
RUN chmod +x ./wait-for-it.sh
USER node

EXPOSE 4500

# Comando por defecto (ahora usa wait-for-it)
CMD ["./wait-for-it.sh", "db:1434", "--", "node", "src/index.js"]