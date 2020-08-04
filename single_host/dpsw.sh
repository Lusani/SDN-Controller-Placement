#! echo ERROR: please source this file !!! like: .
#
# Copyright (C) 2017 FhG Fokus
# This file is part of the Phoenix project.
# This file is part of the 5G!Pagoda project.
#

#find_if_from_ip() {
#  [ -z $1 ] && return
#  IP=$1
#  debug "trying to find interface for ip $IP"
#  [ -x /sbin/ip ] || exit 0
#  /sbin/ip -br -4 a | awk "/$IP\//"'{split($1,a,"@");print a[1]}'
#}

# config
export O5GC_LOG_LVL=5

export O5GC_DPSW_OFP_IPV4=${MME_MGMT_IP}
export O5GC_DPSW_OFP_PORT=6633
export O5GC_DPSW_DATAPATH_ID=0000000000000101

#export O5GC_DPSW_IF2_NAME="${DPSW_S1U_IF}\" mode=\"raw ip"
export O5GC_DPSW_IF2_NAME="${DPSW_S1U_IF}"
if [[ "$DPSW_NETA_IF" == "epc0" ]]; then
	export O5GC_DPSW_IF1_NAME="${DPSW_NETA_IF}\" mode=\"raw ip\" device=\"tun"
else
	export O5GC_DPSW_IF1_NAME=${DPSW_NETA_IF}
fi

