#!/bin/sh

# If a nscd is running, Google Chrome will try to get a cached value from nscd

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -

# Show nscd information before requests are made
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22 | tee nscd-host-info.txt
CACHED_ENTRY_COUNT=$(cat nscd-host-info.txt | grep "current number of cached values" | grep -o "[0-9]*")
echo "CACHED_ENTRY_COUNT => ${CACHED_ENTRY_COUNT}"

# verify 0 cached entry
BC_RESULT=$(echo "${CACHED_ENTRY_COUNT} > 0" | bc)
# it should be 0, false. Cached entry count should NOT be more than 0.
echo "BC_RESULT => ${BC_RESULT}"
if ${BC_RESULT} | grep -w "5"
then
  echo "CACHED_ENTRY_COUNT is good"
else
  echo "CACHED_ENTRY_COUNT is bad"
  exit 1
fi

echo "Show host information:"
find /var -name "hosts"
strings /var/db/nscd/hosts

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
echo "BC_RESULT => ${BC_RESULT}"
echo ${BC_RESULT} | grep -w "1"

# Show nscd information before after are made
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22 | tee nscd-host-info.txt
CACHED_ENTRY_COUNT=$(cat nscd-host-info.txt | grep "current number of cached values" | grep -o "[0-9]*")
echo "CACHED_ENTRY_COUNT => ${CACHED_ENTRY_COUNT}"

echo "Show host information:"
ls -l /var/db/nscd/hosts
strings /var/db/nscd/hosts
