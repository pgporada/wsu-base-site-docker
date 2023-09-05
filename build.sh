#!/bin/bash

phpVersions=("5.5.38" "7.3.33" "8.0.30" "8.2.7")
types=("base" "extensions" "config")

argType=$1
argPHPVersion=$2

if [[ -z ${1} || -z ${2} ]]; then
    echo "Usage: ${0} <type> <php-version>"
    echo "type: base, extensions, config, all"
    echo "php-version: 5.5.38, 7.3.33, 8.0.30, 8.2.7, all"
    exit 1
fi

build() {
    type=$1
    version=$2
    docker build --no-cache -f ./docker/php-$version/$type.Dockerfile -t wsu-php-$version-$type .
    docker tag wsu-php-$version-$type waynestate/php-$type:$version
    docker push waynestate/php-$type:$version
}

if [[ "$argType" == "all" && "$argPHPVersion" == "all" ]]; then
  for version in "${phpVersions[@]}"; do
      for type in "${types[@]}"; do
          build $type $version
      done
  done
elif [ "$argType" == "all" ]; then
  for type in "${types[@]}"; do
      build $type $argPHPVersion
  done
elif [ "$argPHPVersion" == "all" ]; then
  for version in "${phpVersions[@]}"; do
        build $argType $version
  done
else
    build $argType $argPHPVersion
fi
