FROM waynestate/php-extensions:5.5.38
ENV DEBIAN_FRONTEND noninteractive
ENV PHPBREW_SET_PROMPT 1
ENV PHPBREW_RC_ENABLE 1
ENV PHPBREW_ROOT /opt/phpbrew
ENV PHPVERSION 5.5.38

USER 1000

WORKDIR /tmp

# Load custom php.ini files
COPY ./docker/php-${PHPVERSION}/php.ini /tmp/php-configs/php.ini

RUN source ~/.phpbrew/bashrc \
    && sudo cp /tmp/php-configs/php.ini ${PHPBREW_ROOT}/php/php-${PHPVERSION}/etc/php.ini \
    && phpbrew -d clean php-${PHPVERSION}

COPY ./docker/php-${PHPVERSION}/launch.sh /opt/

# Change directories inside the container so that we're "in" the application's folder
WORKDIR /var/www/html

# Fix whatever bitnami did because we don't particularly care about anything they've got inside this container now.
ENV PATH="/usr/bin:/bin:$PATH"

CMD ["/opt/launch.sh"]
