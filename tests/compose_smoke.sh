#!/bin/bash
# A disposable CI runner only; never replace a user's active lab.
set -euo pipefail
if [ "${GITHUB_ACTIONS:-}" != true ] || [ "${RUNNER_OS:-}" != Linux ]; then
  echo 'Run this integration test only on a disposable GitHub-hosted Linux runner.' >&2
  exit 2
fi
for name in victim kali server3; do
  if docker container inspect "$name" >/dev/null 2>&1; then
    echo "Refusing to replace existing container: $name" >&2
    exit 2
  fi
done
LAB_STATE_DIR=$(mktemp -d "${RUNNER_TEMP:?}/csattt-state.XXXXXX")
export LAB_STATE_DIR
umask 077
mkdir -p "$LAB_STATE_DIR/secrets" "$LAB_STATE_DIR/pcap"
openssl rand -base64 24 > "$LAB_STATE_DIR/secrets/victim_password"
openssl rand -base64 24 > "$LAB_STATE_DIR/secrets/server3_password"
compose() { docker compose -f lab/docker-compose.yml "$@"; }
cleanup() {
  result=$?
  trap - EXIT
  if [ "$result" -ne 0 ]; then
    compose ps -a || true
    compose logs --no-color --tail 60 || true
  fi
  compose down --timeout 10 || result=1
  exit "$result"
}
trap cleanup EXIT
compose config --quiet
compose build
compose up -d --wait --wait-timeout 90
bash tests/normal_traffic.sh
if docker exec kali touch /root/scripts/.ci-write-check 2>/dev/null; then
  echo 'Script mount must be read-only' >&2
  exit 1
fi
docker exec kali bash -c 'printf "persistent-output\n" > /root/pcap/.ci-persistence'
compose up -d --force-recreate --no-deps --wait --wait-timeout 90 victim kali
test "$(docker exec kali cat /root/pcap/.ci-persistence)" = persistent-output
docker exec kali test -r /root/scripts/05_reverse_shell.sh
docker exec victim test -r /root/scripts/05_reverse_shell.sh
docker exec kali dig @172.28.0.10 recreated.exfil.lab TXT +tries=1 +time=1 | grep 'status: NXDOMAIN'
echo 'Compose startup, benign traffic, read-only scripts and persistent output verified.'
