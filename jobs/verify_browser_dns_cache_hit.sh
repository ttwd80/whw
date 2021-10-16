#!/bin/bash -e

# If a request DNS resolution request has been made in the last 60 seconds, a cached value is used.
# A request to resolve www.google.com will not be made.

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-hit.py'  | docker exec -i docker-client-1 su - ubuntu

PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep "53:"

# verify
echo "Verify DNS resolution count..."
ACTUAL=$(cat client-tcpdump.txt| grep -w "www.google.com" | wc -l | tr -d ' ')
# 3 request sent, 2 were cache misses and will hit the DNS resolver
# - cache miss, first call, cached
# - cache hit, within one minute of the cached call
# - cache miss, after one minute of the cached call
EXPECTED=2
echo ACTUAL=${ACTUAL}
echo ${ACTUAL} | grep "^${EXPECTED}\$"
