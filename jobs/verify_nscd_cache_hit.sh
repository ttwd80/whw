#!/bin/bash -e

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

# install nscd from tarball
echo 'apt-get install -qq python3 gawk bison flex binutils build-essential' | docker exec -i docker-client-1 su -
echo 'wget -q https://ftp.gnu.org/gnu/glibc/glibc-2.31.tar.gz' | docker exec -i docker-client-1 su -
echo 'tar -C /usr/local/src -x -f glibc-2.31.tar.gz' | docker exec -i docker-client-1 su -
echo 'mkdir /glibc-build && cd /glibc-build && /usr/local/src/glibc-2.31/configure --prefix=/glibc-2.31' | docker exec -i docker-client-1 su -
echo 'cd /glibc-build && make && make install' | docker exec -i docker-client-1 su -
echo 'echo old nscd && ls -l $(which nscd) && ls -l /glibc-build/nscd/nscd && cat /glibc-build/nscd/nscd > $(which nscd) && ls -l $(which nscd)' | docker exec -i docker-client-1 su -

echo '/etc/init.d/nscd start'  | docker exec -i docker-client-1 su -
sleep 5
echo '/etc/init.d/nscd status'  | docker exec -i docker-client-1 su -



# begin

((docker exec -t docker-client-1 tcpdump -n udp) > client-tcpdump.txt)&

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

echo 'DISPLAY=:1 python3 /home/ubuntu/selenium/google-resolve-browser-cache-miss-expire.py'  | docker exec -i docker-client-1 su - ubuntu

echo "Full tcpdump"
cat client-tcpdump.txt

echo "Only with port 53"
cat client-tcpdump.txt | grep -E "\.53: "

echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su - 
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22

# end

# begin

# show nscd stats
# show nscd log
# run selenium
# stop tcpdump
# full tcpdump
# filtered tcpdump
# show nscd log
# show nscd stats
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22
echo 'cat /var/log/nscd.log'  | docker exec -i docker-client-1 su - 

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
