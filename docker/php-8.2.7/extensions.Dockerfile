FROM wsu-php-8.2.7-base:latest
ENV DEBIAN_FRONTEND noninteractive
ENV PHPBREW_SET_PROMPT 1
ENV PHPBREW_RC_ENABLE 1
ENV PHPBREW_ROOT /opt/phpbrew

VOLUME /opt/phpbrew

# Back to the bitnami user
USER 1000

# Install php extensions specific to the required version of PHP.
# Keep in mind these extensions may need to be enabled in the
# appropriate php.ini file too.
RUN source ${HOME}/.phpbrew/bashrc \
    && phpbrew use $(awk '{print $3}' /var/www/html/.phpbrewrc) \
    && phpbrew -d ext install ldap \
    && phpbrew -d ext install xdebug \
    && phpbrew -d ext install github:phpredis/phpredis 5.3.5 \
    && phpbrew -d ext install iconv \
    && phpbrew -d ext install mcrypt \
    && phpbrew -d ext install opcache \
    && phpbrew -d ext install exif \
    && phpbrew -d ext install intl \
    # Compile and Install GD library seperately for FreeType support
    && phpbrew -d ext install gd -- --with-jpeg --with-png --with-zlib --with-freetype --with-gd=shared

# Change directories inside the container so that we're "in" the application's folder
WORKDIR /var/www/html

# Fix whatever bitnami did because we don't particularly care about anything they've got inside this container now.
ENV PATH="/usr/bin:/bin:$PATH"

CMD ["/opt/launch.sh"]
