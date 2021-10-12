FROM ubuntu:20.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install \
    dnsutils \
    wget \
    sudo \
    xvfb \
    tcpdump
RUN wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
RUN apt install ./google-chrome-stable_current_amd64.deb
RUN useradd ubuntu
COPY scripts/init_etc_resolv_conf.sh /root/
CMD sh /root/init_etc_resolv_conf.sh && bash
