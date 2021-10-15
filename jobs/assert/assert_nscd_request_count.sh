#!/bin/bash -e
EXPECTED_COUNT="${1}"
REQUEST_COUNT=$(cat client-tcpdump.txt | cut -b 17- | uniq | grep -w 'www.google.com.' | grep -w 'A.' |  wc -l | tr -d ' ' )

# test
echo "REQUEST_COUNT => ${REQUEST_COUNT}"
echo ${REQUEST_COUNT} | grep -wq "${EXPECTED_COUNT}"
