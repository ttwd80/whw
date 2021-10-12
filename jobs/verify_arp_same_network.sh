#!/bin/sh

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&
sleep 5

echo DISPLAY=:1 python3 /home/ubuntu/selenium/github-resolve-browser-cache.py | su - ubuntu

PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

cat client-tcpdump.txt
cat client-host.txt