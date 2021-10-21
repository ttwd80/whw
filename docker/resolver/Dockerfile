FROM ubuntu:20.04
RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -qq install bind9 dnsutils net-tools tcpdump
CMD /etc/init.d/named start && bash
    
