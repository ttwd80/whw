#!/bin/bash -e

docker ps -a

((docker exec -t docker-client-1 tcpdump -n) > client-tcpdump.txt)&

echo '---'
echo 'By default, files first, then dns.'
echo 'cat /etc/nsswitch.conf | grep hosts' | docker exec -i docker-client-1 su -
echo '---'
echo 'By default, the host we want to resolve does not exist in /etc/hosts.'
echo 'cat /etc/hosts' | docker exec -i docker-client-1 su -
echo '---'
echo 'Forcing /etc/nsswitch.conf to use dns only'
echo 'sed --in-place "s/hosts:.*/hosts: dns/" /etc/nsswitch.conf' | docker exec -i docker-client-1 su -
echo 'cat /etc/nsswitch.conf' | docker exec -i docker-client-1 su -
echo '---'
echo 'Adding an bad entry for www.google.com in /etc/hosts'
echo 'echo "8.8.8.8 www.google.com" >> /etc/hosts' | docker exec -i docker-client-1 su -
echo 'cat /etc/hosts' | docker exec -i docker-client-1 su -
echo '---'

echo 'echo reload-count 0 >> /etc/nscd.conf'  | docker exec -i docker-client-1 su -
echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -

docker exec -t docker-client-1 sh -c 'echo Google Chrome version : $(echo google-chrome --version | su - ubuntu)'

echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-process.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53 or 443"
cat client-tcpdump.txt | grep -E "\.53:|\.443:"

# localhost is not resolved using /etc/hosts and we are sending a request to resolve it
echo "Request to resolve localhost"
COUNT=$(cat client-tcpdump.txt | grep "\.53:" | grep -w 'A\?' | grep -w "localhost" | wc -l)
echo "COUNT = [${COUNT}]"
RESULT=$(echo "${COUNT} > 0" | bc)
# 0 to force fail
test "${RESULT}" = "1"

echo '---'
echo 'Remove the bad entry for www.google.com in /etc/hosts without restarting nscd'
echo '(sed -e "s/8.8.8.8 www.google.com//" /etc/hosts > /tmp/hosts) && (cat /tmp/hosts > /etc/hosts)' | docker exec -i docker-client-1 su -
echo 'cat /etc/hosts' | docker exec -i docker-client-1 su -
echo '---'

((docker exec -t docker-client-1 tcpdump -n) > client-tcpdump.txt)&
echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-process.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Killing tcpdump at - $(date)"
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53 or 443"
# no requests to resolve www.google.com as this was read from /etc/hosts
cat client-tcpdump.txt | grep -E "\.53:|\.443:"
