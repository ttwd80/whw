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

echo '---'
echo 'By default, files first, then dns.'
echo 'cat /etc/nsswitch.conf | grep hosts' | docker exec -i docker-client-1 su -
echo '---'
echo 'By default, the host we want to resolve does not exist in /etc/hosts.'
echo 'cat /etc/hosts' | docker exec -i docker-client-1 su -
echo '---'

echo 'sed --in-place -e "/^.*debug-level/s/0/2/" -e "/^#.*reload-count.*[0-9]$/s/[0-9]*$/0/;/^#.*reload-count.*0$/s/#//" -e "/^#.*logfile.*log$/s/#//" /etc/nscd.conf'  | docker exec -i docker-client-1 su -

echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -

# Show nscd information before requests are made
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh "=="

$(dirname "$0")/assert/assert_nscd_host_entry.sh 0

docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-process.py'  | docker exec -i docker-client-1 su - ubuntu
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-process.py'  | docker exec -i docker-client-1 su - ubuntu

cat /var/log/nscd.log

echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep "\.53:"

# verify
$(dirname "$0")/assert/assert_nscd_request_count.sh 1

# Show nscd information after requests are made
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh ">"

$(dirname "$0")/assert/assert_nscd_host_entry.sh 1