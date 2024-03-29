#!/bin/bash
set -e

phpVersions=("5.5.38" "7.3.33" "8.0.30" "8.2.7")
types=("base" "extensions" "config")

argType="${1}"
argPHPVersion="${2}"

if [[ -z "${1}" || -z "${2}" ]]; then
    echo "Usage: ${0} <type> <php-version>"
    echo "type: base, extensions, config, all"
    echo "php-version: 5.5.38, 7.3.33, 8.0.30, 8.2.7, all"
    exit 1
fi

function build() {
    if [[ -z "${1}" || -z "${2}" ]]; then
        echo "You must supply a 'type' and a 'php version' as arguments."
        return 1
    fi
    local type="${1}"
    local version="${2}"

    docker buildx build -f "./docker/php-${version}/${type}.Dockerfile" \
        --platform "linux/amd64,linux/arm64" \
        --push \
        --tag "waynestate/php-${type}:${version}" \
        .
}

if [[ "${argType}" == "all" && "${argPHPVersion}" == "all" ]]; then
  for version in "${phpVersions[@]}"; do
      for type in "${types[@]}"; do
          build "${type}" "${version}"
      done
  done
elif [ "${argType}" == "all" ]; then
  for type in "${types[@]}"; do
      build "${type}" "${argPHPVersion}"
  done
elif [ "${argPHPVersion}" == "all" ]; then
  for version in "${phpVersions[@]}"; do
        build "${argType}" "${version}"
  done
else
    build "${argType}" "${argPHPVersion}"
fi
