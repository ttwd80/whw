#!/bin/sh

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/github-resolve-browser-cache.py'  | docker exec -i docker-client-1 su - ubuntu

PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep "53:"

# verify - fail on purpose
echo "Verify DNS resolution count..."
ACTUAL=$(cat client-tcpdump.txt| grep "github.com" | grep -v api | wc -l | tr -d ' ')
# 3 request sent, 2 were cache misses and will hit the DNS resolver
# - cache miss, first call, cached
# - cache hit, within one minute of the cached call
# - cache miss, after one minute of the cached call
EXPECTED=2
echo ${ACTUAL} | grep -w ${EXPECTED}
