FROM ubuntu:20.04
ENV DISPLAY=:1
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install \
    dnsutils \
    wget \
    sudo \
    xvfb \
    unzip \
    nscd \
    bc \
    python3-pip \
    tcpdump
RUN wget --quiet "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
RUN apt install -y ./google-chrome-stable_current_amd64.deb
ADD scripts /root/scripts
ADD selenium /home/ubuntu/selenium
RUN pip install selenium && \
    wget --quiet "https://chromedriver.storage.googleapis.com/94.0.4606.61/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip && \
    chmod a+x chromedriver && \
    mv chromedriver /usr/local/bin && \
    useradd -m ubuntu && \
    chown -R ubuntu:ubuntu /home/ubuntu
CMD sh /root/scripts/init_client.sh && bash
