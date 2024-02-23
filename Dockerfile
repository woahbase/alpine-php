# syntax=docker/dockerfile:1
#
ARG IMAGEBASE=frommakefile
#
FROM ${IMAGEBASE}
#
ARG PHPMAJMIN=81
#
ENV \
    PHPMAJMIN=${PHPMAJMIN}
#
RUN set -xe \
    && apk add --no-cache --purge -uU \
        php${PHPMAJMIN} \
        php${PHPMAJMIN}-apcu \
        php${PHPMAJMIN}-common \
        php${PHPMAJMIN}-ctype \
        php${PHPMAJMIN}-curl \
        php${PHPMAJMIN}-dom \
        php${PHPMAJMIN}-fpm \
        php${PHPMAJMIN}-gd \
        php${PHPMAJMIN}-intl \
        php${PHPMAJMIN}-json \
        php${PHPMAJMIN}-mbstring \
        php${PHPMAJMIN}-opcache \
        php${PHPMAJMIN}-openssl \
        php${PHPMAJMIN}-pcntl \
        php${PHPMAJMIN}-pear \
        php${PHPMAJMIN}-pecl-mcrypt \
        php${PHPMAJMIN}-phar \
        php${PHPMAJMIN}-posix \
        php${PHPMAJMIN}-session \
        php${PHPMAJMIN}-sodium \
        php${PHPMAJMIN}-zip \
        php${PHPMAJMIN}-zlib \
    && ln -sf /usr/bin/php${PHPMAJMIN}  /usr/bin/php \
    && ln -sf /usr/bin/pear${PHPMAJMIN} /usr/bin/pear \
    && ln -sf /usr/bin/pecl${PHPMAJMIN} /usr/bin/pecl \
    && ln -sf /usr/sbin/php-fpm${PHPMAJMIN} /usr/sbin/php-fpm \
    && mkdir -p /defaults \
    && mv /etc/php${PHPMAJMIN}/php.ini /defaults/php.ini \
    && mv /etc/php${PHPMAJMIN}/php-fpm.conf /defaults/php-fpm.conf \
    && mv /etc/php${PHPMAJMIN}/php-fpm.d/www.conf /defaults/php-fpm-www.conf \
    && rm -rf /var/cache/apk/* /tmp/*
#
COPY root/ /
#
# ports, volumes entrypoint etc from nginx
# set entrypoint to /usershell for cli/scripts
# ENTRYPOINT ["/init"]
