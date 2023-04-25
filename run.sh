#!/bin/bash

HOST_UID=$(id -u)
HOST_GID=$(id -g)
docker run -v ./base-site:/app --user "${HOST_UID}:${HOST_GID}" -P wsu-base-container
#docker run -v ./base-site:/app -it wsu-base-container bash
