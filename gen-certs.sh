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
sudo find .certs/*/ -type f -name '*.pem' -exec chown root:root {} \;

echo '+) Done!'
