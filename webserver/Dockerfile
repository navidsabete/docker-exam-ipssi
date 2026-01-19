FROM debian:bullseye

WORKDIR /webserver

# Mise à jour et Installation des services
RUN apt-get update && apt-get install -y \
        mariadb-server \
        php \
        php-fpm \
        php-mysql \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
        php-zip \
        wget \
        unzip \
        supervisor \
        && apt clean \
        && rm -rf /var/lib/apt/lists/*

# Création des dossiers web
RUN mkdir -p /var/www/html \
    && mkdir -p /var/www/phpmyadmin \
    && mkdir -p /var/www/wordpress \
    && mkdir -p /var/www/php \
    && chown -R www-data:www-data /var/www

# Copier le contenu local
COPY ./index.html /var/www/html/index.html
COPY ./php/ /var/www/html/php
COPY ./phpmyadmin /var/www/phpmyadmin
COPY ./wordpress /var/www/wordpress

# Créer le dossier pour le socket PHP-FPM
RUN mkdir -p /run/php \
    && chown -R www-data:www-data /run/php

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

EXPOSE 3000

CMD ["/bin/bash", "/init.sh"]