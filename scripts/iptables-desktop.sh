#!/bin/sh
#
# mitchs iptables desktop/laptop config
#
# -------------------------------------------

# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
# variables
# -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
SUBNET=192.168.100
PIHOLE=$SUBNET.200
# =/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=/=

# flush
iptables -F

# deny all default
iptables -P OUTPUT DROP
iptables -P INPUT DROP
iptables -P FORWARD DROP

# dns to pihole
iptables -A OUTPUT -j ACCEPT -d $PIHOLE/24 -p tcp --dport 53 -m state --state NEW
iptables -A OUTPUT -j ACCEPT -d $PIHOLE/24 -p udp --dport 53 -m state --state NEW

# permit local ssh
iptables -A INPUT -s $SUBNET.0/24 -j ACCEPT -p tcp --dport ssh -m state --state NEW
iptables -A INPUT -s $SUBNET.0/24 -j ACCEPT -p tcp --sport ssh -m state --state NEW
iptables -A OUTPUT -d $SUBNET.0/24 -j ACCEPT -p tcp --sport ssh -m state --state ESTABLISHED
iptables -A OUTPUT -d $SUBNET.0/24 -j ACCEPT -p tcp --dport ssh -m state --state ESTABLISHED

# permit outgoing http,https,ftp
iptables -A OUTPUT -j ACCEPT -p tcp --dport 80 -m state --state NEW,ESTABLISHED
iptables -A OUTPUT -j ACCEPT -p tcp --dport 443 -m state --state NEW,ESTABLISHED
iptables -A OUTPUT -j ACCEPT -p tcp --dport 21 -m state --state NEW,ESTABLISHED

# permit outgoing wireguard
iptables -A OUTPUT -j ACCEPT -p udp --dport 51820 -m state --state NEW,ESTABLISHED

# permit loopback
iptables -A OUTPUT -j ACCEPT -o lo

# permit established
iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED,RELATED

# save
if command -v systemctl >/dev/null 2>&1 ; then
	# redhat
	if [ -f /etc/sysconfig/iptables ] ; then
		iptables-save -f /etc/sysconfig/iptables
	# arch
	elif [ -f /etc/iptables/iptables.rules ] ; then
		iptables-save -f /etc/iptables/iptables.rules
	fi
	# gentoo / alpine
elif command -v rc-service >/dev/null 2>&1 ; then
	/etc/init.d/iptables save
fi

