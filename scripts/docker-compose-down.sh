#!/bin/sh
cd docker
docker-compose down

docker info | grep "Root"
mkdir -p /tmp/var-lib-docker
sudo ls -l /var/lib/docker
sudo ls -ld /var/lib/docker
time sudo rsync -ar /var/lib/docker/* /tmp/var-lib-docker
sudo chown -R runner /tmp/var-lib-docker