#!/bin/sh
./scripts/setup-tools.sh

cd docker
docker-compose up -d
sleep 60
docker-compose down