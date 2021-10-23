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



# begin

# show nscd stats
# show nscd log
# start tcpdump
# run selenium
# stop tcpdump
# full tcpdump
# filtered tcpdump
# show nscd log
# show nscd stats
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22
echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su - 

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-process.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep -E "\.53: "

echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su - 
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22

# end

echo 'scd --invalidate=hosts'  | docker exec -i docker-client-1 su -

# begin

# show nscd stats
# show nscd log
# start tcpdump
# run selenium
# stop tcpdump
# full tcpdump
# filtered tcpdump
# show nscd log
# show nscd stats
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22
echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su - 

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-process.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep -E "\.53: "

echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su - 
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22
# end

