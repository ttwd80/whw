#!/bin/bash -e
FILENAME="${1}"
TARGET_HOSTNAME="${2}"
EXPECTED_COUNT="${3}"

ACTUAL_COUNT="$(cat "${FILENAME}" | cut -b 17- | uniq | grep -w "${TARGET_HOSTNAME}" | grep -w 'A.' |  wc -l | tr -d ' ')"

test "${EXPECTED_COUNT}" == "${ACTUAL_COUNT}"