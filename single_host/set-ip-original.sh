#!/bin/bash

if [ -f ./env.sh ]; then
   . ./env.sh
else
   echo "ERROR: ./env.sh not found !!!"
   exit 0
fi

## legacy mode without TUN interfae
function start_net(){
	if [ ! -z $DPSW_S1U_IF ] && [ ! -z $DPSW_S1U_IP ]; then
	   #sudo ip a a ${DPSW_S1U_IP}/24 dev $DPSW_S1U_IF
	   sudo iptables -A INPUT -i $DPSW_S1U_IF -p udp --dport 2152 -j DROP
	fi

	#if [ ! -z $MME_S1C_IF ] && [ ! -z $MME_S1C_IP ]; then
	 #  sudo ip a a ${MME_S1C_IP}/24 dev $MME_S1C_IF
	#fi

	sudo setcap cap_net_admin,cap_net_raw=+ep /opt/phoenix/dist/bin/phoenix


	sudo ip link add vhost0 type veth peer name vdpsw0
	sudo ip link set dev vhost0 arp off
	sudo ip link set dev vdpsw0 arp off
	sudo sudo ethtool -K vhost0 tso off gro off gso off tx off rx off
	sudo sudo ethtool -K vdpsw0 tso off gro off gso off tx off rx off
	sudo ip link set vhost0 up
	sudo ip link set vdpsw0 up
	sudo ip r a 192.168.3.0/24 dev vhost0
	sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 ! -o vhost0 -j MASQUERADE
}

## new TUN mode
function start_net_tun(){
	if [ ! -z $DPSW_S1U_IF ] && [ ! -z $DPSW_S1U_IP ]; then
	 #  sudo ip a a ${DPSW_S1U_IP}/24 dev $DPSW_S1U_IF
	   sudo iptables -A INPUT -i $DPSW_S1U_IF -p udp --dport 2152 -j DROP
	fi

	#if [ ! -z $MME_S1C_IF ] && [ ! -z $MME_S1C_IP ]; then
	 #  sudo ip a a ${MME_S1C_IP}/24 dev $MME_S1C_IF
	#fi

	sudo setcap cap_net_admin,cap_net_raw=+ep /opt/phoenix/dist/bin/phoenix

	## create persistant epc0 interface
	sudo ip tuntap add name $DPSW_NETA_IF mode tun
	sudo ip link set $DPSW_NETA_IF up
	sudo ip r a 192.168.3.0/24 dev $DPSW_NETA_IF
	sudo iptables -t nat -A POSTROUTING -s 192.168.3.0/24 ! -o $DPSW_NETA_IF -j MASQUERADE
	sudo iptables -A FORWARD -i $DPSW_NETA_IF -j ACCEPT
	sudo iptables -A FORWARD -o $DPSW_NETA_IF -j ACCEPT
}

function stop_net(){
	if [ ! -z $DPSW_S1U_IF ] && [ ! -z $DPSW_S1U_IP ]; then
	   #sudo ip a d ${DPSW_S1U_IP}/24 dev $DPSW_S1U_IF
	   sudo iptables -D INPUT -i $DPSW_S1U_IF -p udp --dport 2152 -j DROP
	fi

	#if [ ! -z $MME_S1C_IF ] && [ ! -z $MME_S1C_IP ]; then
	 #  sudo ip a d ${MME_S1C_IP}/24 dev $MME_S1C_IF
	#fi

	sudo iptables -t nat -D POSTROUTING -s 192.168.3.0/24 ! -o $DPSW_NETA_IF -j MASQUERADE
	sudo ip r del 192.168.3.0/24 dev $DPSW_NETA_IF
	sudo ip link del vhost0 >/dev/null
	sudo ip link del vdpsw0 >/dev/null
	sudo ip link del epc0 >/dev/null
}

if [[ "$1" == "down" ]]; then
	stop_net
else
	if [[ "$DPSW_NETA_IF" == "epc0" ]]; then
		start_net_tun
	else
		start_net
	fi
fi
