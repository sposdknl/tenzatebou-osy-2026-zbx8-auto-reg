#!/bin/bash
set -eu

export DEBIAN_FRONTEND=noninteractive

if ! dpkg -s zabbix-agent2 >/dev/null 2>&1; then
    wget -q -O /tmp/zabbix-release.deb "https://repo.zabbix.com/zabbix/8.0/release/debian/pool/main/z/zabbix-release/zabbix-release_latest_8.0+debian13_all.deb"
    dpkg -i /tmp/zabbix-release.deb
    rm -f /tmp/zabbix-release.deb

    apt-get update -qq
    apt-get install -y -qq zabbix-agent2
fi

version=$(dpkg-query -W -f='${Version}\n' zabbix-agent2)
case "$version" in
    8.*|*:8.*) ;;
    *) echo "Neocekavana verze zabbix-agent2: $version" >&2; exit 1 ;;
esac

zabbix_agent2 -V | head -n 1
