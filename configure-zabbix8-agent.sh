#!/bin/bash
set -eu

config=/etc/zabbix/zabbix_agent2.conf
name_file=/var/lib/zabbix/spos-hostname

install -d -m 0755 /var/lib/zabbix
if [ ! -s "$name_file" ]; then
    id=$(tr -d '-' < /proc/sys/kernel/random/uuid | cut -c1-12)
    printf 'tenzatebou-deb13-%s\n' "$id" > "$name_file"
    chmod 0644 "$name_file"
fi

hostname=$(cat "$name_file")
if ! printf '%s\n' "$hostname" | grep -Eq '^tenzatebou-deb13-[[:xdigit:]]{12}$'; then
    echo "Neplatny ulozeny nazev hosta: $hostname" >&2
    exit 1
fi

if [ ! -f "${config}.orig" ]; then
    cp -p "$config" "${config}.orig"
fi

sed -i -E '/^# Nastaveni pro ulohu OSY$/d' "$config"
sed -i -E '/^[[:space:]#]*(Hostname|Server|ServerActive|HostMetadata)=/d' "$config"

cat >> "$config" <<EOF
# Nastaveni pro ulohu OSY
Hostname=$hostname
Server=enceladus.pfsense.cz
ServerActive=enceladus.pfsense.cz
HostMetadata=SPOS
EOF

systemctl enable zabbix-agent2
systemctl restart zabbix-agent2
systemctl status zabbix-agent2 --no-pager

printf 'Zabbix agent 2 bezi jako %s\n' "$hostname"
