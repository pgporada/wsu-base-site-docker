#!/bin/bash

if [[ -z ${1} || -z ${2} ]]; then
    echo "Usage: ${0} <type> <php-version>"
    echo "type: base, extensions, config"
    echo "php-version: 8.2.7"
    exit 1
fi

docker build --no-cache -f docker/php-${2}/${1}.Dockerfile -t wsu-php-${2}-${1} .
