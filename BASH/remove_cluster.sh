systemctl stop pve-cluster
systemctl stop corosync
pmxcfs -l
rm -f /etc/pve/corosync.conf
rm -rf /etc/corosync/*
rm -f /var/lib/corosync/*
killall pmxcfs
systemctl start pve-cluster
systemctl restart corosync
systemctl restart pvedaemon
systemctl restart pveproxy
systemctl restart pvestatd