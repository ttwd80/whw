#!/bin/sh
docker exec -i docker-client-1 sh -c 'apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install curl wget coreutils apt-utils netbase -qq'
