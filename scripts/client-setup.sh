#!/bin/sh
echo "CLIENT_DEB_CACHE_DIR => [${CLIENT_DEB_CACHE_DIR}]"
echo "GOOGLE_CHROME_URL => [${GOOGLE_CHROME_URL}]"

docker exec -i docker-client-1 bash /root/scripts/setup_client.sh "${CLIENT_DEB_CACHE_DIR}" "${GOOGLE_CHROME_URL}"