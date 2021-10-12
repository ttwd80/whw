#!/bin/sh

docker ps -a

sleep 60

docker ps -a

sleep 60

docker ps -a

sleep 60

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

sleep 5

docker exec -t docker-client-1 sh -c "echo whoami | su - ubuntu"
docker exec -t docker-client-1 sh -c "echo 'export DISPLAY=:1 && google-chrome' | su - ubuntu"
# docker exec -t docker-client-1 sh -c "DISPLAY=:1 python3 /home/ubuntu/selenium/github-resolve-browser-cache.py | su - ubuntu"

PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

cat client-tcpdump.txt
cat client-host.txt