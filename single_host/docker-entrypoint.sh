#!/bin/bash

if [ ! -f ./env.sh ]; then
  echo "env.sh not found !!!!"
  exit
fi

. ./env.sh

#MYSQLCMD="mysql"
MYSQLCMD="mysql -h $SQL_MGMT_IP -uroot" ## if mysqld is running on different host

for f in sql/*.sql
do
  #OLD_REALM=mnc001.mcc001.3gppnetwork.org
  #echo "change PLMN to ${O5GC_MCC}/${O5GC_MNC}"
  #sed -i 's/'${OLD_REALM}'/'${O5GC_REALM}'/g' $f

  echo "SQL: import $f"
  $MYSQLCMD < $f
done

#[-n <MNC>] [-c <MCC>] [-i <yes|no>] [-u <number of users to provision>] [-m <CC for MSISDN>]
pushd sql
  echo "Preparing HSS db for plmn $O5GC_MCC/$O5GC_MNC"
  ./prepare_db.sh -n $O5GC_MNC -c $O5GC_MCC -i no -u 0 -m 49

  echo "Adding test SIM to HSS"
  # [-I <IMSI>] [-M <MSISDN>] [-n <DOMAIN_NAME (default: mnc001.mcc001.3gppnetwork.org)>] [-d <DB_ADDRESS>] [-u <USERNAME>] [-k <KEY>] [-a <AMF>] [-o <OP>] [-s <SQN>] [-e <EXTERNAL_IDENTIFIER>] [-t <USAGE_TYPE>] [-v <yes|no>]
  ./provision.sh -I 101650000013346 -M 4930013346 -n ph13346 -k 74f9c96f0a4940663ee90e8e43a81de4 -o 840337c3d45397ce8ea8609ffdc47224 -s 000000001200 -v no
popd

sleep 3
echo "creating interfaces and routes"
# prepare system for TUN
mkdir /dev/net
mknod /dev/net/tun c 10 200
if [[ "$DPSW_NETA_IF" == "epc0" ]]
then
# create TUN interface
  ip tuntap add mode tun name $DPSW_NETA_IF
  ip link set $DPSW_NETA_IF up
  ip r a 192.168.3.0/24 dev $DPSW_NETA_IF
  iptables -t nat -A POSTROUTING -s 192.168.3.0/24 ! -o $DPSW_NETA_IF -j MASQUERADE
else
  echo "222     epc" >>/etc/iproute2/rt_tables
  ip r a default via 10.100.2.1 table epc
  ip rule add oif eth1 table epc
  ip rule add from 10.100.2.128/25 table epc
fi

# setcap cap_net_admin,cap_net_raw=+ep /opt/phoenix/dist/bin/phoenix


echo "Starting sessions"
./start.sh

# Naive check runs checks once a minute to see if either of the processes exited.
echo "sleep 30"
while sleep 30; do
  if tmux ls; then
    echo "sleep 30.."
  else
    echo "tmux session ended..."
    exit 1
  fi
done
