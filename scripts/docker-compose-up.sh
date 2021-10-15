#!/bin/sh
cd docker
docker info
COMPOSE_DOCKER_CLI_BUILD=1 docker compose build
docker compose up -d
