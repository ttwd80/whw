#!/bin/bash -e

# If a nscd is running, Google Chrome will try to get a cached value from nscd

# 2 tests before the browser requests https://www.google.com/favicon.ico
# - 0 current number of cached values reported by nscd -g
# - NSCD_HOSTS_ENTRY should be 0

# 3 tests after the browser requests https://www.google.com/favicon.ico
# - current number of cached values > 0 reported by nscd -g (shows nscd was used)
# - NSCD_HOSTS_ENTRY should be 1
# - tcp dump shows only one entry, we made 3 requests, 1 was not cached, 2 were cached by nscd

docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo 'echo reload-count 0 >> /etc/nscd.conf'  | docker exec -i docker-client-1 su -
echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -

# Show nscd information before requests are made
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh "=="

$(dirname "$0")/assert/assert_nscd_host_entry.sh 0

docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-no-cache.py'  | docker exec -i docker-client-1 su - ubuntu
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-no-cache.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep "\.53:"

# verify
echo "Verify DNS resolution count..."
REQUEST_COUNT=$(cat client-tcpdump.txt | cut -b 17- | uniq | grep -w 'www.google.com.' | grep -w 'A.' |  wc -l | tr -d ' ' )

# test
echo "REQUEST_COUNT => ${REQUEST_COUNT}"
if echo ${REQUEST_COUNT} | grep -wq "1"
then
  echo "REQUEST_COUNT is good."
else
  echo "REQUEST_COUNT is bad."
  exit 1
fi

# Show nscd information after requests are made
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh ">"

echo 'strings /var/cache/nscd/hosts' | docker exec -i docker-client-1 su -
NSCD_HOSTS_ENTRY=$(echo 'strings /var/cache/nscd/hosts | grep -w "www.google.com" | sort | uniq | wc -l | tr -d " "'  | docker exec -i docker-client-1 su -)
echo "NSCD_HOSTS_ENTRY => ${NSCD_HOSTS_ENTRY}"
if echo ${NSCD_HOSTS_ENTRY} | grep -wq "1"
then
  echo "NSCD_HOSTS_ENTRY is good."
else
  echo "NSCD_HOSTS_ENTRY is bad."
  exit 1
fi
