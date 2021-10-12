#!/bin/sh
DOCKER_COMPOSE_VERSION=v2.0.1
wget "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64"
chmod a+x ./docker-compose-linux-x86_64
mv ./docker-compose-linux-x86_64 /usr/local/bin/docker-compose
docker-compose --version && (docker-compose --version | grep "${DOCKER_COMPOSE_VERSION}")
