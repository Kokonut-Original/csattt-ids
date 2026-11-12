#!/bin/bash
set -euo pipefail
case "${LAB_ROLE:-}" in
  victim) user=testuser ;;
  server3) user=testuser2 ;;
  *) echo 'LAB_ROLE must be victim or server3' >&2; exit 2 ;;
esac
test -s /run/secrets/lab_password
password=$(cat /run/secrets/lab_password)
if [[ "$password" == *:* || "$password" == *$'\n'* ]]; then
  echo 'Password must be a single line without colons' >&2; exit 2
fi
id -u "$user" >/dev/null 2>&1 || useradd -m -s /bin/bash "$user"
printf '%s:%s\n' "$user" "$password" | chpasswd
unset password
mkdir -p /run/sshd
touch /var/log/auth.log
chown syslog:adm /var/log/auth.log
ssh-keygen -A
rsyslogd
if [ "$LAB_ROLE" = victim ]; then
  /usr/sbin/sshd
  mkdir -p /var/log/apache2
  apache2ctl start
  exec dnsmasq --no-daemon --conf-file=/dev/null --no-resolv --no-hosts \
    --listen-address=172.28.0.10 --bind-interfaces --local=/exfil.lab/
fi
exec /usr/sbin/sshd -D -e
