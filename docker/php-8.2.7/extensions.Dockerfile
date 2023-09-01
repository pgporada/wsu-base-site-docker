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
    && phpbrew ext install gd \
    && phpbrew ext enable gd \
    && phpbrew ext install redis \
    && phpbrew ext enable redis

# Change directories inside the container so that we're "in" the application's folder
WORKDIR /var/www/html

# Fix whatever bitnami did because we don't particularly care about anything they've got inside this container now.
ENV PATH="/usr/bin:/bin:$PATH"

CMD ["/opt/launch.sh"]
