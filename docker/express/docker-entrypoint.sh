#!/bin/sh

# Script d'entrypoint pour l'installation des dépendances en mode dev
if [ "$NODE_ENV" = "development" ]; then
    npm install
fi

# Script d'entrypoint pour l'import de la base de données
npm run db:import

# Exécution de la commande pour démarrer l'application
exec "$@"
