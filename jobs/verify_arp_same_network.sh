#!/bin/sh
docker ps -a
((docker exec -t docker-client-1 tcpdump -n) > client-tcpdump.txt)&
((docker exec -t docker-client-1 host www.google.com) > client-host.txt)&
PID_TCPDUMP=$(docker exec -t docker-client-1 pidof tcpdump)
docker exec -t docker-client-1 sh -c "kill $PID_TCPDUMP"

cat client-tcpdump.txt
cat client-host.txt