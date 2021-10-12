FROM ubuntu:20.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install \
    dnsutils \
    tcpdump
CMD scripts/init_etc_resolv_conf.sh && bash
