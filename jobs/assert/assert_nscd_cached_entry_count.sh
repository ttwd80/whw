#!/bin/bash -e
OPERATOR="${1}"
echo 'nscd -g'  | docker exec -i docker-client-1 su - | grep "hosts cache:" -A 22 | tee nscd-host-info.txt
CACHED_ENTRY_COUNT=$(cat nscd-host-info.txt | grep "current number of cached values" | grep -o "[0-9]*")

# verify 0 cached entry
BC_RESULT=$(echo "${CACHED_ENTRY_COUNT} ${OPERATOR} 0" | bc)

echo "CACHED_ENTRY_COUNT => ${CACHED_ENTRY_COUNT}"
echo ${BC_RESULT} | grep -wq "1"
