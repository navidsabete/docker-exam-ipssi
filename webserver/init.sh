#!/bin/bash

set -e  # Stop le script si une commande échoue

echo "[INFO] Démarrage temporaire de MariaDB pour initialisation..."
mysqld_safe --skip-networking &
PID=$!

# Attendre que MariaDB soit prêt
until mysqladmin ping --silent; do
    sleep 1
done

echo "[INFO] Création de la base de données et de l'utilisateur..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[INFO] Base de données prête !"

# Arrêter l'instance temporaire
echo "[INFO] Arrêt temporaire de MariaDB avant lancement via Supervisor..."
mysqladmin shutdown
wait $PID

AUTOINDEX=${AUTOINDEX}

echo "[INFO] Génération de la config Nginx avec AUTOINDEX=${AUTOINDEX}"

envsubst '${AUTOINDEX}' \
    < /etc/nginx/conf.d/default.conf.template \
    > /etc/nginx/conf.d/default.conf

echo "[INFO] Démarrage de Supervisor..."
exec /usr/bin/supervisord -n