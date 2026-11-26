#!/bin/bash
set -euo pipefail
# scan_port.sh - Kịch bản 1: Quét cổng
TARGET=172.28.0.10
PCAP_DIR="${PCAP_DIR:-/root/pcap}"
mkdir -p "$PCAP_DIR"
PCAP="$PCAP_DIR/01_port_scan_$(date +%Y%m%d_%H%M%S).pcap"

tcpdump -i eth0 -U -w "$PCAP" net 172.28.0.0/24 &
TCPDUMP_PID=$!
trap 'kill -INT "$TCPDUMP_PID" 2>/dev/null || true; wait "$TCPDUMP_PID" 2>/dev/null || true' EXIT
sleep 0.3
kill -0 "$TCPDUMP_PID"
sleep 2

nmap -n -sV "$TARGET"

sleep 2
kill -INT "$TCPDUMP_PID"
wait "$TCPDUMP_PID" || true
trap - EXIT
