#!/bin/bash

set -e  # Stop le script si une commande échoue

echo "[INFO] Démarrage temporaire de MariaDB pour initialisation..."
mysqld_safe --skip-networking --datadir=/var/lib/mysql &
PID=$!
sleep 5  # laisse le temps au serveur de démarrer

echo "[INFO] Création de la base de données et de l'utilisateur..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "[INFO] Base de données prête !"

echo "[INFO] Arrêt temporaire de MariaDB avant lancement via Supervisor..."
kill $PID
sleep 2

echo "[INFO] Démarrage de Supervisor..."
exec /usr/bin/supervisord -n