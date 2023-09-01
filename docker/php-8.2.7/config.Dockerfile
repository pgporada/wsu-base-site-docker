FROM wsu-php-8.2.7-base:latest
ENV DEBIAN_FRONTEND noninteractive
ENV PHPBREW_SET_PROMPT 1
ENV PHPBREW_RC_ENABLE 1
ENV PHPBREW_ROOT /opt/phpbrew

VOLUME /opt/phpbrew

USER root

# Load custom php.ini files
COPY ./docker/php-8.2.7/php.ini /tmp/php-configs/php.ini

RUN source ${HOME}/.phpbrew/bashrc \
    && sudo cp /tmp/php-configs/php.ini ${PHPBREW_ROOT}/php/${PHPBREW_PHP}/etc/fpm/php.ini \
    && sudo cp /tmp/php-configs/php.ini ${PHPBREW_ROOT}/php/${PHPBREW_PHP}/etc/cli/php.ini \

# Change directories inside the container so that we're "in" the application's folder
WORKDIR /var/www/html

# Fix whatever bitnami did because we don't particularly care about anything they've got inside this container now.
ENV PATH="/usr/bin:/bin:$PATH"

CMD ["/opt/launch.sh"]
