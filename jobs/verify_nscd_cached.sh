#!/bin/sh

# If a nscd is running, Google Chrome will try to get a cached value from nscd

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo 'apt-get install -qq nscd'  | docker exec -i docker-client-1 su -
echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -
docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/github-resolve-browser-no-cache.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep "53:"

# verify
echo "Verify DNS resolution count..."
ACTUAL=$(cat client-tcpdump.txt| grep "github.com" | grep -v api | wc -l | tr -d ' ')
# 3 request sent, all 3 are not cached
SENT=3

# ACTUAL should be less than SENT
echo ACTUAL=${ACTUAL}

# bc returns 1 if the comparison is true
# fail on purpose
BC_RESULT=$(echo "${ACTUAL} < ${SENT}" | bc)
echo "BC_RESULT => ${RESULT}"
echo ${BC_RESULT} | grep -w "0"
