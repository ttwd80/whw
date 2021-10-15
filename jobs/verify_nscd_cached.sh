#!/bin/sh

# If a nscd is running, Google Chrome will try to get a cached value from nscd

# 2 tests before the browser requests https://github.com/favicon.ico
# - 0 current number of cached values reported by nscd -g
# - related to /var/cache/nscd/hosts

# 3 tests after the browser requests https://github.com/favicon.ico
# - current number of cached values > 0 reported by nscd -g (shows nscd was used)
# - related to /var/cache/nscd/hosts - shows github.com is cached by nscd
# - tcp dump shows only one entry, we made 3 requests, 1 was not cached, 2 were cached by nscd

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo 'echo reload-count 0 >> /etc/nscd.conf'  | docker exec -i docker-client-1 su -
echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -

# Show nscd information before requests are made
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22 | tee nscd-host-info.txt
CACHED_ENTRY_COUNT=$(cat nscd-host-info.txt | grep "current number of cached values" | grep -o "[0-9]*")
echo "CACHED_ENTRY_COUNT => ${CACHED_ENTRY_COUNT}"

# verify 0 cached entry
BC_RESULT=$(echo "${CACHED_ENTRY_COUNT} == 0" | bc)
# it should be 0, false. Cached entry count should NOT be more than 0.
echo "BC_RESULT => ${BC_RESULT}"
if echo ${BC_RESULT} | grep -w "1"
then
  echo "CACHED_ENTRY_COUNT is good"
else
  echo "CACHED_ENTRY_COUNT is bad"
  exit 1
fi

echo "Show host information:"
echo 'strings /var/cache/nscd/hosts | grep -w "github.com" | wc -l | tr -d " "'  | docker exec -i docker-client-1 su -
# Test here

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
ACTUAL=$(cat client-tcpdump.txt | cut -b 17- | uniq | grep -w 'github.com.' | grep -w 'A.' |  wc -l | tr -d ' ' )

# test
echo "ACTUAL => ${ACTUAL}"
if echo ${ACTUAL} | grep -w "1"
then
  echo "REQUEST_COUNT is good"
else
  echo "REQUEST_COUNT is bad"
  exit 1
fi

# Show nscd information after requests are made
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22 | tee nscd-host-info.txt
CACHED_ENTRY_COUNT=$(cat nscd-host-info.txt | grep "current number of cached values" | grep -o "[0-9]*")
echo "CACHED_ENTRY_COUNT => ${CACHED_ENTRY_COUNT}"

# verify > 0 cached entry
BC_RESULT=$(echo "${CACHED_ENTRY_COUNT} > 0" | bc)
# it should be > 0.
echo "BC_RESULT => ${BC_RESULT}"
if echo ${BC_RESULT} | grep -w "1"
then
  echo "CACHED_ENTRY_COUNT is good"
else
  echo "CACHED_ENTRY_COUNT is bad"
  exit 1
fi


# Show nscd information before after are made
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22 | tee nscd-host-info.txt
CACHED_ENTRY_COUNT=$(cat nscd-host-info.txt | grep "current number of cached values" | grep -o "[0-9]*")
echo "CACHED_ENTRY_COUNT => ${CACHED_ENTRY_COUNT}"

echo "Show host information:"
echo 'strings /var/cache/nscd/hosts'  | docker exec -i docker-client-1 su -
