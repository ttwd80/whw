#!/bin/bash -e

# If a request DNS resolution request has been made in the last 60 seconds, a cached value is used.
# A request to resolve www.google.com will not be made.

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp or host 1.1.1.1) > client-tcpdump.txt)&

docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-host-resolver-rules.py'  | docker exec -i docker-client-1 su - ubuntu

PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53 and host 1.1.1.1"
cat client-tcpdump.txt | grep "53: |1\.1\.1\.1"

# verify
echo "Verify DNS resolution count..."
ACTUAL=$(cat client-tcpdump.txt| grep -w "www.google.com" | wc -l | tr -d ' ')
echo "EXPECTED=0 as we have provided the mapping, there is no need to query the data."
EXPECTED=0
echo ACTUAL=${ACTUAL}
echo ${ACTUAL} | grep "^${EXPECTED}\$"
