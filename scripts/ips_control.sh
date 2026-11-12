#!/bin/bash
# Called only through ips_mode.sh with fixed mounts. No arbitrary host commands.
set -Eeuo pipefail
umask 077
unit=/units/suricata.service.d/90-csattt-ips.conf
demo=/rules/csattt-ips-demo.rules
checkunit=/units/csattt-ips-rulecheck.service
forward=(-i eth0 -s 172.28.0.20/32 -d 172.28.0.10/32 -p udp --dport 53 -m comment --comment CSATTT_IPS_DNS -j NFQUEUE --queue-num 100 --queue-bypass)
reverse=(-o eth0 -s 172.28.0.10/32 -d 172.28.0.20/32 -p udp --sport 53 -m comment --comment CSATTT_IPS_DNS -j NFQUEUE --queue-num 100 --queue-bypass)
remove_queues() {
  while iptables -w 5 -C INPUT "${forward[@]}" 2>/dev/null; do iptables -w 5 -D INPUT "${forward[@]}"; done
  while iptables -w 5 -C OUTPUT "${reverse[@]}" 2>/dev/null; do iptables -w 5 -D OUTPUT "${reverse[@]}"; done
}
restore_ids() {
  test -f /state/initialized
  remove_queues
  systemctl stop suricata || return 1
  if [ -f "$unit" ]; then
    cmp "$unit" /state/owned-override.conf || return 1
    rm -- "$unit" || return 1
  fi
  if [ -f /state/dropin-dir-was-absent ]; then rmdir /units/suricata.service.d 2>/dev/null || true; fi
  if [ -f "$checkunit" ]; then
    cmp "$checkunit" /state/owned-rulecheck.service || return 1
    systemctl stop csattt-ips-rulecheck.service || return 1
    rm -- "$checkunit" || return 1
  fi
  systemctl daemon-reload || return 1
  systemctl start suricata || return 1
  systemctl is-active --quiet suricata || return 1
  systemctl show suricata -p ExecStart --value | grep -q -- '--af-packet' || return 1
  if [ -f "$demo" ]; then
    cmp "$demo" /state/owned-demo.rules || return 1
    rm -- "$demo" || return 1
  fi
  iptables-save | python3 /repo/scripts/ips_firewall_canonical.py > /state/firewall.after-ids || return 1
  python3 /repo/scripts/ips_firewall_canonical.py < /state/firewall.before.private > /state/firewall.expected || return 1
  cmp /state/firewall.expected /state/firewall.after-ids || return 1
  printf 'IDS restored; only owned queue rules/override removed; original firewall matches.\n'
}
case "${1:-}" in
  init)
    test ! -e /state/initialized
    test ! -e "$unit"
    test ! -e "$demo"
    test ! -e "$checkunit"
    systemctl show suricata -p ExecStart --value | grep -q -- '--af-packet'
    ip -4 address show eth0 | grep -q 'inet 172.28.0.10/24'
    printf '%s\n' "$CSATTT_VICTIM_PID" > /state/victim.pid
    iptables-save > /state/firewall.before.private
    if grep -q CSATTT_IPS_DNS /state/firewall.before.private; then echo 'An existing IPS hook needs review' >&2; exit 2; fi
    sed '/^#/d' /state/firewall.before.private > /state/firewall.before
    cp /rules/local.rules /state/ids.rules
    systemctl show suricata -p FragmentPath -p DropInPaths -p ExecStart -p Type > /state/ids-unit.private.txt
    if [ ! -d /units/suricata.service.d ]; then touch /state/dropin-dir-was-absent; fi
    sha256sum /state/ids.rules /state/firewall.before /state/ids-unit.private.txt > /state/backup.sha256
    sha256sum -c /state/backup.sha256
    touch /state/initialized
    echo 'IPS control initialized; no enforcement enabled.'
    ;;
  enable)
    test -f /state/initialized
    test ! -e "$unit"
    test ! -e "$demo"
    test ! -e "$checkunit"
    cmp /rules/local.rules /state/ids.rules
    test "$CSATTT_VICTIM_PID" = "$(cat /state/victim.pid)"
    rollback_on_error() { code=$?; trap - ERR; restore_ids || true; exit "$code"; }
    trap rollback_on_error ERR
    cat /state/ids.rules /repo/src/suricata/ips/dns-demo.rules > "$demo"
    chmod 644 "$demo"
    cp "$demo" /state/owned-demo.rules
    test ! -e "$checkunit"
    cat > /state/owned-rulecheck.service <<'CHECK'
[Unit]
Description=CSATTT one-shot Suricata rule validation
[Service]
Type=oneshot
ExecStart=/usr/bin/suricata -T -c /etc/suricata/suricata.yaml -S /var/lib/suricata/rules/csattt-ips-demo.rules
ProtectSystem=full
ProtectHome=true
CHECK
    cp /state/owned-rulecheck.service "$checkunit"
    chmod 644 "$checkunit"
    systemctl daemon-reload
    systemctl start csattt-ips-rulecheck.service
    systemctl show csattt-ips-rulecheck.service -p Result -p ExecMainStatus > /state/rulecheck.result
    rm -- "$checkunit"
    systemctl daemon-reload
    mkdir -p /units/suricata.service.d
    cat > /state/owned-override.conf <<UNIT
# CSATTT DNS lab IPS; remove with ips_mode.sh ids.
[Service]
ExecStart=
ExecStart=/usr/bin/nsenter -t $CSATTT_VICTIM_PID -n -- /usr/bin/suricata -D -q 100 -c /etc/suricata/suricata.yaml -S /var/lib/suricata/rules/csattt-ips-demo.rules --pidfile /run/suricata.pid
UNIT
    cp /state/owned-override.conf "$unit"
    chmod 644 "$unit"
    systemctl daemon-reload
    systemctl restart suricata
    ready=0
    for ((attempt=0; attempt<30; attempt++)); do
      if awk '$1==100 {found=1} END {exit !found}' /proc/net/netfilter/nfnetlink_queue 2>/dev/null; then ready=1; break; fi
      sleep 1
    done
    test "$ready" = 1
    iptables -w 5 -I OUTPUT 1 "${reverse[@]}"
    iptables -w 5 -I INPUT 1 "${forward[@]}"
    trap - ERR
    echo 'IPS queue 100 enabled only for UDP DNS between .20 and .10 inside victim network namespace.'
    ;;
  ids) restore_ids ;;
  status)
    systemctl is-active suricata
    systemctl show suricata -p ExecStart -p MainPID
    iptables-save -c | grep CSATTT_IPS_DNS || true
    cat /proc/net/netfilter/nfnetlink_queue 2>/dev/null || true
    ;;
  *) echo 'Use ips_mode.sh init|enable|ids|status' >&2; exit 2 ;;
esac
