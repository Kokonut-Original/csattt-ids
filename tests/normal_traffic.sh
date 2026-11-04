#!/bin/bash
# Test luu luong BINH THUONG: kiem tra 5 rule KHONG bao nham (FP)
# Yeu cau: lab dang chay, Suricata dang nghe br-lab va ghi log vao ~/lab/log
# Mong doi: fast.log trong
LOG=~/lab/log/fast.log
> $LOG                      # lam trong log (khong dung rm vi Suricata dang mo file)

echo "[1] Ping 3 goi toi victim"
sudo docker exec kali ping -c 3 -q 172.28.0.10 | tail -2

echo "[2] Mo web victim 1 lan"
sudo docker exec kali curl -s -o /dev/null -w "    HTTP %{http_code}\n" http://172.28.0.10

echo "[3] SSH dung mat khau 1 lan"
sudo docker exec kali sshpass -p '123456' ssh -q -o StrictHostKeyChecking=no testuser@172.28.0.10 'echo "    dang nhap: $(whoami)"'

echo "[4] Tra DNS 3 lan (victim khong chay DNS server nen bi tu choi, nhung goi van di qua mang)"
for i in 1 2 3; do
  sudo docker exec kali dig @172.28.0.10 example.com +tries=1 +time=1 > /dev/null 2>&1
  echo "    da gui truy van $i"
done

sleep 6                     # cho Suricata ghi log
echo "===== fast.log ====="; cat $LOG; echo "===== het ====="
