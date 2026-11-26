#!/bin/bash
# Test rule 1000003 (ICMP flood) truc tiep trong lab
# Cach dung: bash tests/icmp_flood_live.sh normal   -> ping 3 goi, KHONG duoc bao
#            bash tests/icmp_flood_live.sh attack   -> ping 50 goi (5 goi/giay), PHAI bao
LOG=~/lab/log/fast.log
> $LOG

if [ "$1" = "attack" ]; then
  echo "[Tan cong] Ping 50 goi, moi goi cach 0.2 giay, toi victim"
  sudo docker exec kali ping -c 50 -i 0.2 -q 172.28.0.10 | tail -2
else
  echo "[Binh thuong] Ping 3 goi toi victim"
  sudo docker exec kali ping -c 3 -q 172.28.0.10 | tail -2
fi

sleep 6
echo "===== fast.log ====="; cat $LOG; echo "===== het ====="
