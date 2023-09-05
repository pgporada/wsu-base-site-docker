FROM bitnami/laravel:6
ENV DEBIAN_FRONTEND noninteractive
ENV PHPBREW_SET_PROMPT 1
ENV PHPBREW_RC_ENABLE 1
ENV PHPBREW_ROOT /opt/phpbrew
ENV PHPVERSION 7.3.33

USER root

# Get basic system utilities
RUN apt-get update && apt-get install -y -qq curl wget make git

# Get packages so phpbrew can compile php from source
# https://php.watch/articles/compile-php-ubuntu
# https://github.com/phpbrew/phpbrew/wiki/Troubleshooting/#compiling-php74-with-the-openssl-extension-error-in-ubuntu-2204
RUN apt-get update && apt-get install -y -qq curl \
    wget \
    make \
    git \
    gcc \
    lbzip2 \
    m4 \
    build-essential \
    autoconf \
    libtool \
    bison \
    re2c \
    pkg-config \
    bzip2 \
    sqlite3 \
    libsqlite3-dev \
    libxml2-dev \
    libssl-dev \
    libbz2-dev \
    zlib1g-dev \
    libmcrypt-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libreadline-dev \
    libjpeg-dev \
    libpng-dev \
    libxpm-dev \
    libpq-dev \
    libicu-dev \
    libfreetype6 \
    libfreetype6-dev \
    libldap2-dev \
    libxslt-dev \
    libldb-dev \
    libzip-dev \
    libsystemd-dev \
    libbz2-dev \
    libxml2-dev \
    libwebp-dev \
    liblzma-dev \
    lzma-dev \
    xz-utils \
    libonig-dev \
    libonig5 \
    libidn11-dev \
    libkrb5-dev \
    librtmp-dev \
    libssh2-1-dev \
    libsystemd-dev

RUN composer self-update

# Build custom freetype with freetype-config enabled for ease of use including freetype with GD on PHP 7+ versions that
# don't use the --with-freetype flag when building
# https://github.com/docker-library/php/issues/865#issuecomment-557360089
WORKDIR /tmp
RUN wget https://download.savannah.gnu.org/releases/freetype/freetype-2.8.1.tar.gz \
    && tar xzvf freetype-2.8.1.tar.gz \
    && cd freetype-2.8.1 \
    && ./configure --prefix="/usr/include" \
    && make \
    && make install

# Install phpbrew so we can get whatever funky version of php we need
# https://phpbrew.github.io/phpbrew/
WORKDIR /tmp
RUN curl -L -O https://github.com/phpbrew/phpbrew/raw/1.28.0/phpbrew \
    && chmod +x phpbrew \
    && mv phpbrew /usr/bin/phpbrew

# Install php based on the .phpbrewrc
# https://github.com/phpbrew/phpbrew#known-issues
RUN mkdir -p /opt/phpbrew \
    && phpbrew init --root=/opt/phpbrew \
    && phpbrew -d update --old \
    && phpbrew install ${PHPVERSION} \
        +default  \
        +sqlite  \
        +mysql  \
        +fpm  \
        +mcrypt  \
        +openssl  \
        +session  \
        +soap  \
        +sockets  \
        +tokenizer  \
        +zip  \
        +zlib \
    && chown -R bitnami:bitnami /opt/phpbrew

# Use a real shell that has features like 'source' because it's 2023 and not 1970
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Back to the bitnami user
USER 1000

# Run the base-site setup steps ensuring that we're on the version of php we expect
RUN wget https://raw.githubusercontent.com/phpbrew/phpbrew/1.28.0/shell/bashrc -O /tmp/bashrc \
    && sudo mkdir -p /root/.phpbrew \
    && sudo cp /tmp/bashrc /root/.phpbrew/ \
    && echo 'source /root/.phpbrew/bashrc' | sudo tee -a /root/.bashrc \
    && mkdir -p ~/.phpbrew \
    && cp /tmp/bashrc ~/.phpbrew/ \
    && echo 'source ~/.phpbrew/bashrc' >> ~/.bashrc \
    && chown -R 1000:1000 ${HOME}/.phpbrew \
    && source ~/.phpbrew/bashrc \
    && phpbrew -d switch ${PHPVERSION}

COPY ./docker/php-${PHPVERSION}/launch.sh /opt/

# Change directories inside the container so that we're "in" the application's folder
WORKDIR /var/www/html

# Fix whatever bitnami did because we don't particularly care about anything they've got inside this container now.
ENV PATH="/usr/bin:/bin:$PATH"

CMD ["/opt/launch.sh"]
