#!/bin/bash
# scan_port.sh - Kịch bản 1: Quét cổng
TARGET=172.28.0.10
PCAP=pcap/01_port_scan.pcap

tcpdump -i eth0 -w $PCAP &
TCPDUMP_PID=$!
sleep 2

nmap -sV $TARGET

sleep 2
kill $TCPDUMP_PID
