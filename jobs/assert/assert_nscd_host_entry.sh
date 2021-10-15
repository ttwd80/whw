#!/bin/bash -e
EXPECTED_COUNT="${1}"
NSCD_HOSTS_ENTRY=$(echo 'strings /var/cache/nscd/hosts | grep -w "www.google.com" | sort | uniq | wc -l | tr -d " "'  | docker exec -i docker-client-1 su -)
echo "NSCD_HOSTS_ENTRY => ${NSCD_HOSTS_ENTRY}"
echo ${NSCD_HOSTS_ENTRY} | grep -wq "${EXPECTED_COUNT}"
