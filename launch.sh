#!/bin/bash

source /opt/phpbrew/bashrc
phpbrew use $(awk '{print $3}' /app/.phpbrewrc)
php -v
make install
make build
make watch
