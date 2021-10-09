# whw

What happens when

## Requirement

- `docker-compose` - `v2.0.0`

- `docker` - `20.10.8`

## Steps

1. Start the containers by running `docker-compose up --build && docker-compose down`.

2. The last line should say
`docker-resolver-1  |  * Starting domain name service... named            [ OK ]`.

3. Open a new terminal window and run `docker exec -it docker-resolver-1 /bin/sh`.

4. Run the command `tcpdump -n udp`.

5. Open a new terminal window and run `docker exec -it docker-client-1 /bin/sh`.

6. Run the command `dig +short github.com`.

7. Go back to the terminal for `docker-resolver-1` and look at the output.

## Sample output

### Client

```console
# dig +short github.com
13.237.44.5
# 
```

### Resolver

```console
# tcpdump udp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
04:24:19.114410 IP docker-client-1.docker_custom.49639 > b3568a4abd73.domain: 47679+ [1au] A? github.com. (51)
04:24:19.116227 IP b3568a4abd73.54547 > h.root-servers.net.domain: 26094 [1au] A? _.com. (46)
04:24:19.116922 IP b3568a4abd73.59146 > 192.168.65.5.domain: 26580+ PTR? 53.190.97.198.in-addr.arpa. (44)
04:24:19.127796 IP h.root-servers.net.domain > b3568a4abd73.54547: 26094-| 0/13/1 (258)
04:24:19.129317 IP 192.168.65.5.domain > b3568a4abd73.59146: 26580 1/0/0 PTR h.root-servers.net. (76)
04:24:19.130113 IP b3568a4abd73.46155 > 192.168.65.5.domain: 19889+ PTR? 5.65.168.192.in-addr.arpa. (43)
04:24:19.148015 IP 192.168.65.5.domain > b3568a4abd73.46155: 19889 NXDomain 0/0/0 (43)
04:24:19.152476 IP b3568a4abd73.34853 > g.gtld-servers.net.domain: 47293 [1au] A? github.com. (51)
04:24:19.152996 IP b3568a4abd73.53865 > 192.168.65.5.domain: 48361+ PTR? 30.93.42.192.in-addr.arpa. (43)
04:24:19.165281 IP 192.168.65.5.domain > b3568a4abd73.53865: 48361 1/0/0 PTR g.gtld-servers.net. (75)
04:24:19.311177 IP g.gtld-servers.net.domain > b3568a4abd73.34853: 47293-| 0/10/2 (437)
04:24:19.634541 IP b3568a4abd73.53644 > G.ROOT-SERVERS.NET.domain: 32384% [1au] A? dns1.p08.nsone.net. (59)
04:24:19.634672 IP b3568a4abd73.41890 > G.ROOT-SERVERS.NET.domain: 58568% [1au] AAAA? dns2.p08.nsone.net. (59)
04:24:19.634736 IP b3568a4abd73.35638 > G.ROOT-SERVERS.NET.domain: 16607% [1au] A? dns3.p08.nsone.net. (59)
04:24:19.634827 IP b3568a4abd73.38952 > G.ROOT-SERVERS.NET.domain: 58273% [1au] AAAA? dns1.p08.nsone.net. (59)
04:24:19.634941 IP b3568a4abd73.48150 > G.ROOT-SERVERS.NET.domain: 7819% [1au] A? dns2.p08.nsone.net. (59)
04:24:19.634955 IP b3568a4abd73.58694 > G.ROOT-SERVERS.NET.domain: 918% [1au] AAAA? dns3.p08.nsone.net. (59)
04:24:19.635083 IP b3568a4abd73.59663 > ns-421.awsdns-52.com.domain: 60480 [1au] A? github.com. (51)
04:24:19.635104 IP b3568a4abd73.50202 > G.ROOT-SERVERS.NET.domain: 14891% [1au] A? ns-520.awsdns-01.net. (61)
04:24:19.635283 IP b3568a4abd73.48220 > G.ROOT-SERVERS.NET.domain: 16868% [1au] AAAA? ns-520.awsdns-01.net. (61)
04:24:19.635431 IP b3568a4abd73.48955 > 192.168.65.5.domain: 7014+ PTR? 4.36.112.192.in-addr.arpa. (43)
04:24:19.635580 IP b3568a4abd73.38242 > G.ROOT-SERVERS.NET.domain: 53024% [1au] A? dns4.p08.nsone.net. (59)
04:24:19.635881 IP b3568a4abd73.34144 > G.ROOT-SERVERS.NET.domain: 21261% [1au] AAAA? dns4.p08.nsone.net. (59)
04:24:19.648115 IP ns-421.awsdns-52.com.domain > b3568a4abd73.59663: 60480*-$ 1/8/1 A 13.237.44.5 (278)
04:24:19.649327 IP b3568a4abd73.47078 > b.gtld-servers.net.domain: 16022 [1au] DS? github.com. (51)
04:24:19.652938 IP 192.168.65.5.domain > b3568a4abd73.48955: 7014 1/0/0 PTR G.ROOT-SERVERS.NET. (75)
04:24:19.654053 IP b3568a4abd73.33307 > 192.168.65.5.domain: 52716+ PTR? 165.193.251.205.in-addr.arpa. (46)
04:24:19.656164 IP 192.168.65.5.domain > b3568a4abd73.33307: 52716 1/0/0 PTR ns-421.awsdns-52.com. (80)
04:24:19.657140 IP b3568a4abd73.56998 > 192.168.65.5.domain: 48747+ PTR? 30.14.33.192.in-addr.arpa. (43)
04:24:19.670878 IP 192.168.65.5.domain > b3568a4abd73.56998: 48747 1/0/0 PTR b.gtld-servers.net. (75)
04:24:19.674208 IP b.gtld-servers.net.domain > b3568a4abd73.47078: 16022*-| 0/4/1 (466)
04:24:19.726933 IP b3568a4abd73.49362 > c.gtld-servers.net.domain: 63897 [1au] DNSKEY? com. (44)
04:24:19.727867 IP b3568a4abd73.60445 > 192.168.65.5.domain: 53191+ PTR? 30.92.26.192.in-addr.arpa. (43)
04:24:19.730417 IP 192.168.65.5.domain > b3568a4abd73.60445: 53191 1/0/0 PTR c.gtld-servers.net. (75)
04:24:19.779885 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.41890: 58568-| 0/0/1 (75)
04:24:19.780838 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.35638: 16607-| 0/0/1 (75)
04:24:19.780851 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.53644: 32384-| 0/0/1 (75)
04:24:19.780862 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.38952: 58273-| 0/0/1 (75)
04:24:19.783919 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.58694: 918-| 0/0/1 (75)
04:24:19.783986 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.48150: 7819-| 0/0/1 (75)
04:24:19.787841 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.50202: 14891-| 0/0/1 (77)
04:24:19.788117 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.34144: 21261-| 0/0/1 (75)
04:24:19.788125 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.48220: 16868-| 0/0/1 (77)
04:24:19.788191 IP G.ROOT-SERVERS.NET.domain > b3568a4abd73.38242: 53024-| 0/0/1 (75)
04:24:19.904069 IP c.gtld-servers.net.domain > b3568a4abd73.49362: 63897*-| 2/0/1 DNSKEY, DNSKEY (486)
04:24:20.073698 IP b3568a4abd73.56580 > m.gtld-servers.net.domain: 41887% [1au] AAAA? dns2.p08.nsone.net. (59)
04:24:20.074723 IP b3568a4abd73.53763 > 192.168.65.5.domain: 22327+ PTR? 30.83.55.192.in-addr.arpa. (43)
04:24:20.077389 IP b3568a4abd73.47430 > m.gtld-servers.net.domain: 49169% [1au] AAAA? dns1.p08.nsone.net. (59)
04:24:20.078982 IP b3568a4abd73.42039 > m.gtld-servers.net.domain: 5694% [1au] A? dns2.p08.nsone.net. (59)
04:24:20.079056 IP b3568a4abd73.42721 > m.gtld-servers.net.domain: 8120% [1au] AAAA? dns3.p08.nsone.net. (59)
04:24:20.079319 IP b3568a4abd73.53964 > m.gtld-servers.net.domain: 45790% [1au] A? dns3.p08.nsone.net. (59)
04:24:20.079956 IP b3568a4abd73.59877 > m.gtld-servers.net.domain: 23684% [1au] A? dns1.p08.nsone.net. (59)
04:24:20.085109 IP b3568a4abd73.60501 > m.gtld-servers.net.domain: 27747% [1au] A? dns4.p08.nsone.net. (59)
04:24:20.085540 IP b3568a4abd73.53010 > m.gtld-servers.net.domain: 1099% [1au] A? ns-520.awsdns-01.net. (61)
04:24:20.085863 IP b3568a4abd73.40701 > m.gtld-servers.net.domain: 56983% [1au] AAAA? ns-520.awsdns-01.net. (61)
04:24:20.086260 IP b3568a4abd73.36881 > m.gtld-servers.net.domain: 31843% [1au] AAAA? dns4.p08.nsone.net. (59)
04:24:20.092191 IP 192.168.65.5.domain > b3568a4abd73.53763: 22327 1/0/0 PTR m.gtld-servers.net. (75)
04:24:20.200331 IP m.gtld-servers.net.domain > b3568a4abd73.56580: 41887-| 0/6/7 (502)
04:24:20.200454 IP m.gtld-servers.net.domain > b3568a4abd73.47430: 49169-| 0/6/7 (502)
04:24:20.200860 IP m.gtld-servers.net.domain > b3568a4abd73.42039: 5694-| 0/6/7 (502)
04:24:20.202554 IP m.gtld-servers.net.domain > b3568a4abd73.42721: 8120-| 0/6/7 (502)
04:24:20.202563 IP m.gtld-servers.net.domain > b3568a4abd73.53964: 45790-| 0/6/7 (502)
04:24:20.202645 IP m.gtld-servers.net.domain > b3568a4abd73.59877: 23684-| 0/6/7 (502)
04:24:20.208590 IP m.gtld-servers.net.domain > b3568a4abd73.60501: 27747-| 0/6/7 (502)
04:24:20.208710 IP m.gtld-servers.net.domain > b3568a4abd73.40701: 56983-| 0/7/1 (497)
04:24:20.208719 IP m.gtld-servers.net.domain > b3568a4abd73.53010: 1099-| 0/7/1 (497)
04:24:20.208849 IP m.gtld-servers.net.domain > b3568a4abd73.36881: 31843-| 0/6/7 (502)
04:24:20.248835 IP b3568a4abd73.domain > docker-client-1.docker_custom.49639: 47679 1/0/1 A 13.237.44.5 (83)
04:24:20.456469 IP b3568a4abd73.55072 > dns3.p01.nsone.net.domain: 16205% [1au] A? dns3.p08.nsone.net. (59)
04:24:20.456518 IP b3568a4abd73.49669 > dns3.p01.nsone.net.domain: 26242% [1au] AAAA? dns2.p08.nsone.net. (59)
04:24:20.456859 IP b3568a4abd73.55697 > dns1.p01.nsone.net.domain: 45491% [1au] A? dns1.p08.nsone.net. (59)
04:24:20.456925 IP b3568a4abd73.40549 > dns1.p01.nsone.net.domain: 48882% [1au] A? dns2.p08.nsone.net. (59)
04:24:20.457386 IP b3568a4abd73.51883 > 192.168.65.5.domain: 29150+ PTR? 65.44.51.198.in-addr.arpa. (43)
04:24:20.457593 IP b3568a4abd73.58670 > dns1.p01.nsone.net.domain: 40865% [1au] A? dns4.p08.nsone.net. (59)
04:24:20.457942 IP b3568a4abd73.57354 > dns1.p01.nsone.net.domain: 43295% [1au] AAAA? dns4.p08.nsone.net. (59)
04:24:20.458421 IP b3568a4abd73.40420 > ns-771.awsdns-32.net.domain: 27323% [1au] AAAA? ns-520.awsdns-01.net. (61)
04:24:20.458558 IP b3568a4abd73.40487 > dns3.p01.nsone.net.domain: 58093% [1au] AAAA? dns1.p08.nsone.net. (59)
04:24:20.458621 IP b3568a4abd73.52442 > ns-1921.awsdns-48.co.uk.domain: 8326% [1au] A? ns-520.awsdns-01.net. (61)
04:24:20.459198 IP b3568a4abd73.35249 > dns1.p01.nsone.net.domain: 43278% [1au] AAAA? dns3.p08.nsone.net. (59)
04:24:20.459831 IP 192.168.65.5.domain > b3568a4abd73.51883: 29150 1/0/0 PTR dns3.p01.nsone.net. (75)
04:24:20.460848 IP b3568a4abd73.53892 > 192.168.65.5.domain: 46665+ PTR? 1.44.51.198.in-addr.arpa. (42)
04:24:20.462666 IP 192.168.65.5.domain > b3568a4abd73.53892: 46665 1/0/0 PTR dns1.p01.nsone.net. (74)
04:24:20.463437 IP b3568a4abd73.45416 > 192.168.65.5.domain: 2723+ PTR? 3.195.251.205.in-addr.arpa. (44)
04:24:20.476015 IP 192.168.65.5.domain > b3568a4abd73.45416: 2723 1/0/0 PTR ns-771.awsdns-32.net. (78)
04:24:20.476675 IP b3568a4abd73.54012 > 192.168.65.5.domain: 59907+ PTR? 129.199.251.205.in-addr.arpa. (46)
04:24:20.478413 IP 192.168.65.5.domain > b3568a4abd73.54012: 59907 1/0/0 PTR ns-1921.awsdns-48.co.uk. (83)
04:24:20.482951 IP ns-1921.awsdns-48.co.uk.domain > b3568a4abd73.52442: 8326*-$ 1/4/9 A 205.251.194.8 (335)
04:24:20.514215 IP ns-771.awsdns-32.net.domain > b3568a4abd73.40420: 27323*-$ 1/4/9 AAAA 2600:9000:5302:800::1 (347)
04:24:20.557801 IP dns3.p01.nsone.net.domain > b3568a4abd73.55072: 16205*- 2/0/1 A 198.51.44.72, RRSIG (168)
04:24:20.557811 IP dns1.p01.nsone.net.domain > b3568a4abd73.55697: 45491*- 2/0/1 A 198.51.44.8, RRSIG (168)
04:24:20.557819 IP dns3.p01.nsone.net.domain > b3568a4abd73.49669: 26242*- 2/0/1 AAAA 2a00:edc0:6259:7:8::2, RRSIG (180)
04:24:20.558307 IP dns1.p01.nsone.net.domain > b3568a4abd73.57354: 43295*- 2/0/1 AAAA 2a00:edc0:6259:7:8::4, RRSIG (180)
04:24:20.558390 IP dns1.p01.nsone.net.domain > b3568a4abd73.40549: 48882*- 2/0/1 A 198.51.45.8, RRSIG (168)
04:24:20.558398 IP dns1.p01.nsone.net.domain > b3568a4abd73.58670: 40865*- 2/0/1 A 198.51.45.72, RRSIG (168)
04:24:20.558542 IP dns3.p01.nsone.net.domain > b3568a4abd73.40487: 58093*- 2/0/1 AAAA 2620:4d:4000:6259:7:8:0:1, RRSIG (180)
04:24:20.560533 IP dns1.p01.nsone.net.domain > b3568a4abd73.35249: 43278*- 2/0/1 AAAA 2620:4d:4000:6259:7:8:0:3, RRSIG (180)
```

## Explanation

TODO
