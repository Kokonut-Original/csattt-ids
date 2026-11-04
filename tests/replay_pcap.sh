#!/bin/bash
# Chay lai 5 file pcap tan cong qua Suricata (che do doc file -r)
# Cach dung: bash tests/replay_pcap.sh <thu-muc-pcap>   (khong ghi thi mac dinh la: pcap)
# Mong doi: moi pcap sinh canh bao cua rule tuong ung; pcap 04 trong (FN, xem bao cao)
PCAP_DIR=${1:-pcap}
RULES=src/suricata/local.rules

for name in 01_port_scan 02_ssh_bruteforce 03_icmp_flood 04_dns_tunnel 05_reverse_shell; do
  OUT=~/lab/out-$name
  rm -rf $OUT; mkdir -p $OUT          # Suricata chua chay nen xoa an toan
  sudo suricata -r $PCAP_DIR/${name}*.pcap -S $RULES -l $OUT > /dev/null 2>&1
  echo "===== $name ====="
  cat $OUT/fast.log
done
