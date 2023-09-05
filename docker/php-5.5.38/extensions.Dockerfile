FROM waynestate/php-base:5.5.38
ENV DEBIAN_FRONTEND noninteractive
ENV PHPBREW_SET_PROMPT 1
ENV PHPBREW_RC_ENABLE 1
ENV PHPBREW_ROOT /opt/phpbrew
ENV PHPVERSION 5.5.38

# Back to the bitnami user
USER 1000

# Install php extensions specific to the required version of PHP.
# Keep in mind these extensions may need to be enabled in the
# appropriate php.ini file too.
RUN source ~/.phpbrew/bashrc \
    && phpbrew -d switch 5.5.38 \
    && phpbrew -d ext install openssl \
    && phpbrew -d ext install json \
    && phpbrew -d ext install ldap \
    && phpbrew -d ext install github:xdebug/xdebug 2.3.3 \
    && phpbrew -d ext install github:phpredis/phpredis 3.1.6 \
    && phpbrew -d ext install gd -- --with-jpeg-dir="/usr/lib/x86_64-linux-gnu" --with-png-dir="/usr/lib/x86_64-linux-gnu" --with-zlib-dir="/usr" --with-freetype-dir="/usr/include" --with-gd=shared \
    && phpbrew -d ext install iconv \
    && phpbrew -d ext install exif

COPY ./docker/php-${PHPVERSION}/launch.sh /opt/

# Change directories inside the container so that we're "in" the application's folder
WORKDIR /var/www/html

# Fix whatever bitnami did because we don't particularly care about anything they've got inside this container now.
ENV PATH="/usr/bin:/bin:$PATH"

CMD ["/opt/launch.sh"]
