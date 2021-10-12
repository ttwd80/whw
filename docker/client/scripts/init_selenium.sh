#!/bin/sh
Xvfb :1 -screen 0 1600x1200x24+32 &
pip install selenium
wget --quiet "https://chromedriver.storage.googleapis.com/94.0.4606.61/chromedriver_linux64.zip"
unzip chromedriver_linux64.zip
chmod a+x chromedriver
mv chromedriver /usr/local/bin

pip install selenium

useradd -m ubuntu
