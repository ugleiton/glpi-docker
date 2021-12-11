FROM php:7.3-apache

ENV VERSION_GLPI=9.3.2
ENV LANG=en_US
COPY docker-entrypoint-pre.sh /opt/
RUN apt-get update -qq \
    #dependencias
    && rm /etc/apt/preferences.d/no-debian-php \
    && apt install --yes --no-install-recommends \
        gnupg \
        libcurl3-dev \
        libxml2-dev \
        lsb-release \
        libonig-dev \
        libzip-dev \
        wget \
        cron \
        supervisor \
        libldb-dev \
        libldap2-dev \
        libc-client-dev \
        libkrb5-dev \
        libbz2-dev \
        libpng-dev \
        ca-certificates \
        netcat \
    && rm -r /var/lib/apt/lists/* \
    #configurações php
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/php.list \
    && curl https://packages.sury.org/php/apt.gpg | apt-key add - \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && pecl install APCu \
    && docker-php-ext-enable apcu \
    && echo "apc.enabled=1" >> /usr/local/etc/php/conf.d/apcu.ini \
    && echo "apc.enable_cli=1" >> /usr/local/etc/php/conf.d/apcu.ini \
    && docker-php-ext-install mysqli \
        curl \
        xml \
        ldap \
        imap \
        mbstring \
        xmlrpc \
        intl \
        zip \
        bz2 \
        gd \
    #configurações glpi
    && wget -P /tmp/ https://github.com/glpi-project/glpi/releases/download/${VERSION_GLPI}/glpi-${VERSION_GLPI}.tgz \
    && tar -xzvf /tmp/glpi-${VERSION_GLPI}.tgz -C /tmp/\
    && cp -Rap /tmp/glpi/* /var/www/html/ \
    && chown -R www-data:www-data /var/www/html/ \
    && curl https://raw.githubusercontent.com/eficode/wait-for/master/wait-for --output /opt/wait-for \
    && chmod +x /opt/docker-entrypoint-pre.sh \
    && chmod +x /opt/wait-for \
    && echo "*/2 * * * * www-data /usr/bin/php /var/www/html/front/cron.php &>/dev/null" >> /etc/cron.d/glpi \
    && chmod 0644 /etc/cron.d/* \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY checkinstall.php /var/www/html/scripts/
COPY supervisor.conf /etc/supervisor/conf.d/

ENTRYPOINT [ ] 
CMD ["/bin/sh", "-c", "/opt/./wait-for ${MYSQL_HOST}:3306 -- /usr/bin/supervisord -n"]