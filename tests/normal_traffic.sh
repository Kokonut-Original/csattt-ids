#!/bin/bash
# Bounded benign checks; never truncate the running sensor's logs.
set -euo pipefail
: "${LAB_STATE_DIR:?Set LAB_STATE_DIR to the local state directory}"
test -s "$LAB_STATE_DIR/secrets/victim_password"
echo '[1] Three pings to victim'
docker exec kali ping -n -c 3 -q 172.28.0.10
echo '[2] One HTTP request to victim'
docker exec kali curl -fsS -o /dev/null -w 'HTTP %{http_code}\n' http://172.28.0.10
echo '[3] One valid SSH session; password read through stdin'
cat "$LAB_STATE_DIR/secrets/victim_password" | docker exec -i kali bash -c '
  IFS= read -r SSHPASS
  export SSHPASS
  sshpass -e ssh -q -o StrictHostKeyChecking=accept-new -o ConnectTimeout=5 \
    testuser@172.28.0.10 "id -un"
'
echo '[4] Three DNS queries to the internal lab domain'
for i in 1 2 3; do
  docker exec kali dig @172.28.0.10 "normal$i.exfil.lab" TXT +tries=1 +time=1 +short
done
echo 'Check only new Suricata/Wazuh records in this run window; do not clear logs.'
