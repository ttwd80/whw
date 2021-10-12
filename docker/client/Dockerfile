FROM ubuntu:20.04
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install \
    dnsutils \
    wget \
    sudo \
    xvfb \
    unzip \
    python3-pip \
    tcpdump
RUN wget --silent "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
RUN apt install -y ./google-chrome-stable_current_amd64.deb
ADD scripts /root/scripts
ADD selenium /home/ubuntu/selenium
CMD sh /root/init_client.sh && bash
