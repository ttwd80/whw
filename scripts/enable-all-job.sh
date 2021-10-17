#!/bin/sh
if test "$(uname -s)" = "Darwin"
then
  echo "This needs to be run in a Linux environment. Try docker."
  exit 1
fi

JOBS_YML_FILE=$(dirname "$0")/../.github/workflows/jobs.yml
IF_VALUE="true"
if test "${1}" = "false"
then
  IF_VALUE="false"
fi
echo "IF_VALUE => ${IF_VALUE}"
sed -E  "s/^    if: [a-z]*$/    if: ${IF_VALUE}/g" --in-place ${JOBS_YML_FILE}


