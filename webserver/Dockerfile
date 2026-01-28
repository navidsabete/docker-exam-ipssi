FROM debian:bullseye

WORKDIR /webserver

# Mise à jour et Installation des services
RUN apt-get update && apt-get install -y openssl

# SSL auto-signé
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -subj "/C=FR/ST=Occitanie/L=Montpellier/O=Student/CN=webserver.local" \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt

# Mise à jour et Installation des services
RUN apt-get update && apt-get install -y \
        mariadb-server \
        php \
        php-fpm \
        php-mysql \
        php-curl \
        php-cli \
        php-gd \
        php-mbstring \
        php-xml \
        php-zip \
        wget \
        unzip \
        supervisor \
        nginx \
        gettext-base \
        && apt clean \
        && rm -rf /var/lib/apt/lists/*


# Création dossier de socket PHP-FPM
RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

# Création des dossiers web
COPY conf/nginx-template.conf /etc/nginx/conf.d/default.conf.template
RUN mkdir -p /var/www/html \
    && mkdir -p /var/www/phpmyadmin \
    && mkdir -p /var/www/wordpress \
    && mkdir -p /var/www/php \
    && chown -R www-data:www-data /var/www

# Copier le contenu web local
COPY ./index.html /var/www/index.html
COPY ./php/ /var/www/php
COPY ./phpmyadmin /var/www/phpmyadmin
COPY ./wordpress /var/www/wordpress

# Télécharger Wordpress & PhpMyAdmin
RUN wget https://wordpress.org/latest.tar.gz -P /tmp \
    && tar -xzf /tmp/latest.tar.gz -C /tmp \
    && mv /tmp/wordpress/* /var/www/wordpress/ \
    && rm -rf /tmp/wordpress /tmp/latest.tar.gz

RUN wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -P /tmp \
    && unzip /tmp/phpMyAdmin-latest-all-languages.zip -d /tmp \
    && mv /tmp/phpMyAdmin-*-all-languages/* /var/www/phpmyadmin/ \
    && rm -rf /tmp/*

# Copier supervisord pour gérer le multi-processus dans un conteneur
COPY conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copier le script d'initialisation
COPY ./init.sh /init.sh
RUN chmod +x /init.sh

# Port accessible pour le traffic
EXPOSE 3000 443

# Exécution lors du démarrage du conteneur
CMD ["/bin/bash", "/init.sh"]