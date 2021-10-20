#!/bin/bash -ex
PACAKGES_TO_INSTALL="dnsutils \
    wget \
    sudo \
    xvfb \
    unzip \
    nscd \
    bc \
    python3-pip \
    tcpdump"

DEB_CACHE_LOCATION="/tmp/.deb-client"
DEB_ARCHIVE_LOCATION="/var/cache/apt/archives"

useradd -m ubuntu

apt-get update -qq

echo "Copying from cache to var"
for f in ${DEB_CACHE_LOCATION}/*.deb
do
  cp ${f} ${DEB_ARCHIVE_LOCATION}
done

echo "Downloading..."
apt-get install ${PACAKGES_TO_INSTALL} --download-only -y

echo "Copying from var to cache"
for f in ${DEB_ARCHIVE_LOCATION}/*.deb
do
  cp ${f} ${DEB_CACHE_LOCATION}
done

DEBIAN_FRONTEND=noninteractive apt-get -qq install ${PACAKGES_TO_INSTALL}

wget --quiet "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
apt install -y ./google-chrome-stable_current_amd64.deb
pip install selenium

wget --quiet "https://chromedriver.storage.googleapis.com/95.0.4638.17/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
chmod a+x chromedriver
mv chromedriver /usr/local/bin

chown -R ubuntu:ubuntu /home/ubuntu

sh $(dirname "$0")/init_etc_resolv_conf.sh
sh $(dirname "$0")/init_selenium.sh
