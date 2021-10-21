#!/bin/bash -ex
useradd -m ubuntu

pip install selenium

chown -R ubuntu:ubuntu /home/ubuntu

sh $(dirname "$0")/init_etc_resolv_conf.sh
sh $(dirname "$0")/init_selenium.sh
