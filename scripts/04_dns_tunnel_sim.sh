#!/bin/bash
set -euo pipefail
# Kịch bản 4: Giả lập DNS tunnel bằng dig

DNS_SERVER="172.28.0.10"
FAKE_DOMAIN="exfil.lab"
IFACE="eth0"
SO_LAN=40

PCAP_DIR="${PCAP_DIR:-/root/pcap}"
mkdir -p "$PCAP_DIR"
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="$PCAP_DIR/04_dns_tunnel_$TIME.pcap"

echo "Bắt đầu bắt gói tin, lưu vào $PCAP"
tcpdump -i "$IFACE" -U -w "$PCAP" host "$DNS_SERVER" and port 53 &
PID=$!
trap 'kill -INT "$PID" 2>/dev/null || true; wait "$PID" 2>/dev/null || true' EXIT
sleep 0.3
kill -0 "$PID"
sleep 2

echo "Gửi $SO_LAN truy vấn DNS subdomain ngẫu nhiên"
for i in $(seq 1 $SO_LAN); do
    CHUOI=$(head -c 16 /dev/urandom | base32 | tr -d '=' | tr 'A-Z' 'a-z')
    dig @"$DNS_SERVER" "$CHUOI.phan$i.$FAKE_DOMAIN" TXT +short +time=1 +tries=1 > /dev/null
    sleep 0.2
done

sleep 2
kill -INT "$PID"
wait "$PID" || true
trap - EXIT

echo "Xong rồi."