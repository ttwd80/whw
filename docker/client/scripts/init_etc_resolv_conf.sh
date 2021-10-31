#!/bin/sh
cat /etc/resolv.conf > /root/resolv.conf.original
cat /etc/resolv.conf | sed 's/nameserver .*/nameserver 172.23.0.53/' > /root/resolv.conf.custom
cat /etc/resolv.conf | sed 's/nameserver .*/nameserver 9.9.9.9/' > /root/resolv.conf.quad9
cat /root/resolv.conf.quad9 > /etc/resolv.conf
