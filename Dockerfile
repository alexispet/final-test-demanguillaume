# Utilisez une image Node.js en tant que base pour les deux étapes
FROM node:21.6-alpine3.18 AS builder

# Répertoire de travail dans l'image
WORKDIR /app

# Copiez les fichiers nécessaires pour installer les dépendances
COPY package.json package-lock.json /app/

# Installez les dépendances en mode production
RUN npm ci --only=production

# Copiez le reste des fichiers dans l'image
COPY . /app

# Script d'entrypoint pour l'installation des dépendances en mode dev et l'import de la base de données
COPY docker/express/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint
ENTRYPOINT [ "docker-entrypoint" ]
# ENTRYPOINT ["/app/docker-entrypoint.sh"]

# COPY docker/next/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
# RUN chmod +x /usr/local/bin/docker-entrypoint

# Nouvelle étape de build pour créer une image légère
FROM node:21.6-alpine3.18

LABEL org.opencontainers.image.source https://github.com/alexispet/final-test-demanguillaume

# Répertoire de travail dans la nouvelle image
WORKDIR /app

# Copiez seulement les fichiers nécessaires depuis l'étape précédente
COPY --from=builder /app /app

# Exposez le port sur lequel l'application s'exécute
EXPOSE 3000

# Commande pour démarrer l'application
CMD ["npm", "run", "start"]
