#!/bin/sh
GOOGLE_CHROME_DRIVER_LISTING_URL="https://chromedriver.chromium.org/downloads"
HASH_GOOGLE_CHROME_DEB_LAST_MODIFIED=$(curl --silent --head ${GOOGLE_CHROME_URL} | grep -i "last-modified:" | md5sum | cut -b 1-6)
HASH_GOOGLE_CHROME_DRIVER_LATEST_VERSION=$(curl --silent "${GOOGLE_CHROME_DRIVER_LISTING_URL}" | grep -o 'href="https://[^\"]*"' | grep path | grep -o '[0-9][0-9\.]*' | head -1 | md5sum | cut -b 1-6)
echo "::set-output name=hash::${HASH_GOOGLE_CHROME_DEB_LAST_MODIFIED}-${HASH_GOOGLE_CHROME_DRIVER_LATEST_VERSION}"