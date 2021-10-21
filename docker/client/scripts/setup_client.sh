#!/bin/bash -e
TMP_TARGET_DIR="${1}"
GOOGLE_CHROME_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB_TARGET_DIR="/var/cache/apt/archives"
echo "TMP_TARGET_DIR => [${TMP_TARGET_DIR}]"
echo "GOOGLE_CHROME_URL => [${GOOGLE_CHROME_URL}]"
GOOGLE_CHROME_FILENAME=$(echo ${GOOGLE_CHROME_URL} | sed 's|^.*/||g')
PACKAGES_TO_INSTALL="$($(dirname "$0")/packages-to-install.txt)"
GOOGLE_CHROME_DRIVER_LISTING_URL="https://chromedriver.chromium.org/downloads"
GOOGLE_CHROME_DRIVER_BINARY_FILENAME="chromedriver"

USING_CACHE=""
cd ${TMP_TARGET_DIR}
if test -f ${TMP_TARGET_DIR}/${GOOGLE_CHROME_FILENAME}
then
  echo "Using cached download: ${GOOGLE_CHROME_URL}"
  USING_CACHE="yes"
else
  wget ${GOOGLE_CHROME_URL}
  USING_CACHE="no"
fi

GOOGLE_DEB_DEP=$(dpkg -I ${GOOGLE_CHROME_FILENAME} | grep "^ Depends: " | sed -e 's/,/\n/g' -e 's/:/\n/' | sed -e 's/^ //g' | sed 's/ .*//g' | grep -v Depends)

if test "${USING_CACHE}" = "no"
then
  apt-get install -qq --download-only ${GOOGLE_DEB_DEP}
  apt-get install -qq --download-only ${PACKAGES_TO_INSTALL}
  cp ${DEB_TARGET_DIR}/*.deb ${TMP_TARGET_DIR}
else
  cp ${TMP_TARGET_DIR}/*.deb ${DEB_TARGET_DIR}
fi


DEBIAN_FRONTEND=noninteractive apt-get install -qq ${GOOGLE_DEB_DEP}
DEBIAN_FRONTEND=noninteractive apt-get install -qq ${PACKAGES_TO_INSTALL}
#Install Google Chrome
DEBIAN_FRONTEND=noninteractive apt-get install -qq ${TMP_TARGET_DIR}/${GOOGLE_CHROME_FILENAME}


if test "${USING_CACHE}" = "no"
then
  GOOGLE_CHROME_VERSION_X_Y_Z=$(dpkg -I ${GOOGLE_CHROME_FILENAME}  | grep "Version" | cut -f 2 -d ":" | sed 's/^ //' | grep -o '[0-9]*\.[0-9*]\.[0-9]*')
  GOOGLE_CHROME_DRIVER_VERSION=$(curl --silent ${GOOGLE_CHROME_DRIVER_LISTING_URL} | grep -o "${GOOGLE_CHROME_VERSION_X_Y_Z}.[0-9]*" | uniq | head -1)
  echo "GOOGLE_CHROME_DRIVER_VERSION => [${GOOGLE_CHROME_DRIVER_VERSION}]"
  
  GOOGLE_CHROME_DRIVER_FILENAME=chromedriver_linux64.zip
  GOOGLE_CHROME_DRIVER_URL="https://chromedriver.storage.googleapis.com/${GOOGLE_CHROME_DRIVER_VERSION}/${GOOGLE_CHROME_DRIVER_FILENAME}"
  echo "GOOGLE_CHROME_DRIVER_URL => [${GOOGLE_CHROME_DRIVER_URL}]"
  wget "${GOOGLE_CHROME_DRIVER_URL}"
  unzip "${GOOGLE_CHROME_DRIVER_FILENAME}"
  rm ${GOOGLE_CHROME_DRIVER_FILENAME}
fi

chmod a+x ${GOOGLE_CHROME_DRIVER_BINARY_FILENAME}
cp ${GOOGLE_CHROME_DRIVER_BINARY_FILENAME} /usr/local/bin
${GOOGLE_CHROME_DRIVER_BINARY_FILENAME} --version
