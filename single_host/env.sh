#! echo ERROR: please source this file !!! like: .
#
# Copyright (C) 2018 FhG Fokus
# This file is part of the Phoenix project.

## PLMN
export O5GC_MCC=100
export O5GC_MNC=10
export O5GC_NETWORK_ID=o5gc
export O5GC_OPERATOR_ID=3gppnetwork.org
export O5GC_REALM=$(printf %s.mnc%03d.mcc%03d.%s ${O5GC_NETWORK_ID} ${O5GC_MNC} ${O5GC_MCC} ${O5GC_OPERATOR_ID})

## dpsw
if [ -f /.dockerenv ]; then
	## for docker
########
	#export DPSW_S1U_IF=s1u
	#export DPSW_S1U_IP=192.168.11.50
	#export DPSW_NETA_IF=eth0
	export DPSW_S1U_IF=ens4
        export DPSW_S1U_IP=11.0.0.26
        #export DPSW_NETA_IF=ens3
        export DPSW_NETA_IF=ens3
##########
else
#	export DPSW_S1U_IF=ens3
#	export DPSW_S1U_IF=tunfhg
#	export DPSW_S1U_IP=10.0.0.18
#	export DPSW_NETA_IF=epc0
#######
        export DPSW_S1U_IF=ens4
#       export DPSW_S1U_IF=tunfhg
        export DPSW_S1U_IP=11.0.0.26
        #export DPSW_NETA_IF=ens3
        export DPSW_NETA_IF=epc0
#######
	## dpsw --> for bt local host
	#export DPSW_S1U_IF=lo
	#export DPSW_S1U_IP=127.0.4.210
	#export DPSW_NETA_IF=lo
fi


## mme
export MME_MGMT_IP=127.0.253.80
export MME_NETD_IP=127.0.4.80
## s1c_ip/if is used for routing gtpu!
if [ -f /.dockerenv ]; then
	## docker setup
	#export MME_S1C_IF=eth1

        export MME_S1C_IF=ens4
else
	#export MME_S1C_IF=br-s1c
	true
fi
##mme s1c --> for bt local host
#export MME_S1C_IF=lo
#export MME_S1C_IP=127.0.253.80
#export O5GC_MME_S1AP_BIND=$DPSW_S1U_IP

#############
export MME_S1C_IF=ens4
export MME_S1C_IP=11.0.0.26
export O5GC_MME_S1AP_BIND=$DPSW_S1U_IP
#############
## bt
export BT_MGMT_IP=127.0.253.110

## bt dpsw
export BTDPSW_MGMT_IP=127.0.253.230

## hss
export HSS_MGMT_IP=127.0.253.70

## igw
export INETGW_NETA_IP=127.0.1.43

## db
if [ -f /.dockerenv ]; then
	## docker setup (--link db)
	export SQL_MGMT_IP=db
else
	export SQL_MGMT_IP=127.0.0.1
fi
export DB_MGMT=$SQL_MGMT_IP

## s1ap
#export O5GC_MME_S1AP_BIND=0.0.0.0
#export O5GC_MME_S1AP_BIND=$MME_S1C_IP
## mme s1ap bind --> for bt local host
#export O5GC_MME_S1AP_BIND=${MME_MGMT_IP}
export O5GC_BT_S1AP_BIND=${BT_MGMT_IP}
export O5GC_S1AP_PORT=36412

## diameter
export O5GC_DIA_PORT=3868

export O5GC_HSS_DIA_FQDN=hss.mgmt.${O5GC_REALM}
export O5GC_HSS_DIA_REALM=${O5GC_REALM}
export O5GC_HSS_DIA_BIND=${HSS_MGMT_IP}

export O5GC_MME_DIA_FQDN=mme1.mgmt.${O5GC_REALM}
export O5GC_MME_DIA_REALM=${O5GC_REALM}
export O5GC_MME_DIA_BIND=${MME_MGMT_IP}

## femtocell
export O5GC_FEMTOCELL_S1C_1=193.175.132.175
export O5GC_FEMTOCELL_S1U_1=$DPSW_S1U_IP

export O5GC_FEMTOCELL_S1C_2=127.0.10.173

## zabbix
export O5GC_ZABBIX_SERVER_IP=127.0.253.2
export O5GC_ZABBIX_SERVER_PORT=10051

#flowmon
export O5GC_FLOWMON_DB_HOST=${DB_MGMT}
export O5GC_FLOWMON_DB_NAME=flowmon_db
export O5GC_FLOWMON_DB_USER=flowmon
export O5GC_FLOWMON_DB_PW=flowmon
