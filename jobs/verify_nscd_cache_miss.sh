#!/bin/bash -e

# If a nscd is running, Google Chrome will try to get a cached value from nscd

# 2 tests before the first browser requests https://www.google.com/favicon.ico
# - 0 current number of cached values reported by nscd -g
# - NSCD_HOSTS_ENTRY should be 0

# First set of requests to https://www.google.com/favicon.ico

# Verify:
# - 1 DNS request uncached
# - Cached entry count > 0 (www.google.com,  accounts.google.com, etc)
# - www.google.com should be in /var/cache/nscd/hosts

# invalidate the hosts cache
# nscd --invalidate=hosts

# Verify
# - 1 DNS request uncached - unchanged
# - Cached entry count == 0
# - www.google.com should NOT be in /var/cache/nscd/hosts

# Another set of requests to https://www.google.com/

# Verify
# - 2 DNS request uncached - increased
# - Cached entry count == 1
# - www.google.com should be in /var/cache/nscd/hosts


docker ps -a

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo '---'
echo 'By default, files first, then dns.'
echo 'cat /etc/nsswitch.conf | grep hosts' | docker exec -i docker-client-1 su -
echo '---'
echo 'By default, the host we want to resolve does not exist in /etc/hosts.'
echo 'cat /etc/hosts' | docker exec -i docker-client-1 su -
echo '---'

echo 'sed --in-place -e "/^.*debug-level/s/0/10/" -e "/^#.*reload-count.*[0-9]$/s/[0-9]*$/0/;/^#.*reload-count.*0$/s/#//" -e "/^#.*logfile.*log$/s/#//" /etc/nscd.conf' | docker exec -i docker-client-1 su -
echo 'cat /etc/nscd.conf | grep -E "debug-level|reload-count|logfile" | grep -v "^#"' | docker exec -i docker-client-1 su -

echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -

# Show nscd information before requests are made
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh "=="

$(dirname "$0")/assert/assert_nscd_host_entry.sh 0

docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'

# First set of requests to https://www.google.com/
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-process.py'  | docker exec -i docker-client-1 su - ubuntu
echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"
echo "/var/log/nscd.log:"
echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su -
echo "Full tcpdump"
cat client-tcpdump.txt

# verify
$(dirname "$0")/assert/assert_nscd_request_count.sh 1
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh ">"
$(dirname "$0")/assert/assert_nscd_host_entry.sh 1

# invalidate hosts
echo 'nscd --invalidate=hosts'  | docker exec -i docker-client-1 su -

# verify
$(dirname "$0")/assert/assert_nscd_request_count.sh 1
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh "=="
$(dirname "$0")/assert/assert_nscd_host_entry.sh 1 # contains expired

# Another set of requests to https://www.google.com/
((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-expire.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"
echo "/var/log/nscd.log:"
echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su -
echo "Full tcpdump"
cat client-tcpdump.txt

# verify
$(dirname "$0")/assert/assert_nscd_request_count.sh 2
$(dirname "$0")/assert/assert_nscd_cached_entry_count.sh ">"
$(dirname "$0")/assert/assert_nscd_host_entry.sh 1

echo "Only with port 53"
cat client-tcpdump.txt | grep "\.53:"
