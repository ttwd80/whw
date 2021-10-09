FROM ubuntu:20.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install dnsutils
CMD cat /etc/resolv.conf | sed 's/nameserver .*/nameserver 172.23.0.53/' > /tmp/resolv.conf && \
    cat /tmp/resolv.conf > /etc/resolv.conf && \
    rm /tmp/resolv.conf && \
    bash