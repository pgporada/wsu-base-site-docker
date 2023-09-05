#!/bin/bash

source ${HOME}/.phpbrew/bashrc
phpbrew use 7.3.33

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
