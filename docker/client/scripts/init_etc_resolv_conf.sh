#!/bin/sh
cat /etc/resolv.conf > /root/resolv.conf.original
cat /etc/resolv.conf | sed 's/nameserver .*/nameserver 172.23.0.53/' > /root/resolv.conf.custom
cat /etc/resolv.conf | sed 's/nameserver .*/nameserver 208.67.222.123/' > /root/resolv.conf.opendns
cat /root/resolv.conf.custom > /etc/resolv.conf
