#!/bin/bash
# Control only the classroom DNS IPS demonstration on the Ubuntu Docker host.
set -euo pipefail
action=${1:-status}
case "$action" in init|enable|ids|status) ;; *) echo 'Usage: ips_mode.sh init|enable|ids|status' >&2; exit 2;; esac
repo=$(cd "$(dirname "$0")/.." && pwd)
state_root=${LAB_STATE_DIR:-"$HOME/lab"}
state=$(realpath -m "$state_root/ips-state")
case "$state" in "$repo"|"$repo/"*) echo 'IPS state must be outside the repository' >&2; exit 2;; esac
mkdir -p "$state"
chmod 700 "$state"
docker image inspect csattt-ips-tools:local >/dev/null
victim_pid=$(docker inspect victim --format '{{.State.Pid}}')
victim_ip=$(docker inspect victim --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
[[ "$victim_pid" =~ ^[1-9][0-9]*$ ]] && [ "$victim_ip" = 172.28.0.10 ]
docker run --rm --pid host --network container:victim --cap-add NET_ADMIN \
  -e CSATTT_VICTIM_PID="$victim_pid" \
  -v /run/systemd:/run/systemd:ro \
  -v /etc/systemd/system:/units \
  -v /var/lib/suricata/rules:/rules \
  -v "$repo:/repo:ro" -v "$state:/state" \
  csattt-ips-tools:local /repo/scripts/ips_control.sh "$action"
