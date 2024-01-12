#!/bin/bash
set -e

mkdir -p .certs/

echo "+) Removing old certs"
sudo find .certs/ -type f -name '*.pem' -delete

echo "+) Generating new certs"
cd .certs
minica -domains '*.wayne.localhost'
cd ..

echo "+) Fixing permissions"
# OSX uses staff instead of root as the group. Let's find it regardless of system.
sudo find .certs/*/ -type f -name '*.pem' -exec chown ${UID}:${GROUPS} {} \;

echo '+) Done!'
