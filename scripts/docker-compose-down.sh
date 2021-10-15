#!/bin/sh
cd docker
docker-compose down

mkdir -p /tmp/var-lib-docker
time sudo rsync -av /var/lib/docker/* /tmp/var-lib-docker
sudo chown -R runner /tmp/var-lib-docker