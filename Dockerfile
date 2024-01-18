# Utilisez une image Node.js en tant que base pour les deux étapes
FROM node:21.6-alpine3.18 AS builder

# Copiez le reste des fichiers dans l'image
COPY . /app

# Répertoire de travail dans l'image
WORKDIR /app

# Installez les dépendances en mode production
RUN npm install

# Nouvelle étape de build pour créer une image légère
FROM node:21.6-alpine3.18 AS app

# LABEL org.opencontainers.image.source https://github.com/alexispet/final-test-demanguillaume

# Répertoire de travail dans la nouvelle image
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json .
COPY --from=builder /app/database ./database
COPY --from=builder /app/app.js .

EXPOSE 3000
COPY /docker/express/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

CMD ["npm", "run", "start"]
