#!/bin/sh
docker ps -a
((docker exec -t docker_client tcpdump -n) > client-tcpdump.txt)&
((docker exec -t docker_client host www.google.com) > client-host.txt)&
PID_TCPDUMP=$(docker exec -t docker_client pidof tcpdump)
docker exec -t docker_client sh -c "kill $PID_TCPDUMP"

cat client-tcpdump.txt
cat client-host.txt