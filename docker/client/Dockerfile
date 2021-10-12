FROM ubuntu:20.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install \
    dnsutils \
    tcpdump
COPY scripts/init_etc_resolv_conf.sh /root/
CMD sh /root/init_etc_resolv_conf.sh && bash
