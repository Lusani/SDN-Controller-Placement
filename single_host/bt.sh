#! /bin/bash
#
# Copyright (C) 2017 FhG Fokus
# This file is part of the Phoenix project.
# This file is part of the 5G!Pagoda project.
#

export O5GC_LOG_LVL=5

# module configuration

## s1ap 
export O5GC_BT_S1AP_THREADS=2
export O5GC_BT_S1AP_PORT=36413
export O5GC_MME_S1AP_PORT=${O5GC_S1AP_PORT}

## ofp
export O5GC_BT_OFP_PORT=6633

export O5GC_BT_MME_NAME=mme1.mgmt

export O5GC_BT_UE_COUNT=1000
export O5GC_BT_UE_BASE=$(printf %03d%02d1234568000 ${O5GC_MCC} ${O5GC_MNC})

export O5GC_BT_ENB_1_TAC=600
export O5GC_BT_ENB_1_CELLID=1
export O5GC_BT_ENB_1_NAME=eNodeB1
export O5GC_BT_ENB_1_S1AP_IP=${BT_S1AP_IP}

export O5GC_DEFAULT_APN=default
export O5GC_BT_SEND_DATA=0
export O5GC_BT_BTOFS_RUNNING=0
