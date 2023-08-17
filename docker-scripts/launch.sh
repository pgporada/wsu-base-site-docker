#!/bin/bash

source ${HOME}/.phpbrew/bashrc
phpbrew use $(awk '{print $3}' /var/www/html/.phpbrewrc)

if [[ ${1} == "php-fpm" ]]; then
    #sudo php-fpm -F
    sudo ${PHPBREW_ROOT}/php/${PHPBREW_PHP}/sbin/php-fpm -v
    sudo ${PHPBREW_ROOT}/php/${PHPBREW_PHP}/sbin/php-fpm --fpm-config /opt/php-fpm/php-fpm.conf -F
else
    php -v
    make install
    make build
    make watch
fi
