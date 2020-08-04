#! echo ERROR: please source this file !!! like: .
#
# Copyright (C) 2017 FhG Fokus
# This file is part of the Phoenix project.
# This file is part of the 5G!Pagoda project.
#

#netcat -v -q 5 HSSDB 3306
#mysql --host HSSDB -u hss --password=hss  hss_db


export O5GC_LOG_LVL=5

export O5GC_HSS_DB_NAME=hss_db
export O5GC_HSS_DB_HOST=${SQL_MGMT_IP}
export O5GC_HSS_DB_USER=hss
export O5GC_HSS_DB_PW=hss
