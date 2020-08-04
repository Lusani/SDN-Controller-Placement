#!/bin/sh
# (c) 2018 FOKUS
# script for legacy docker deployments w/o 'docker network'


DHUB=dockerhub.nakao-lab.org:5000 #fokus.fraunhofer.de:5000
DNSPACE=o5gcore #phoenix/docker-phoenix/phoenix-bin
DTAG=latest
PIPEW=pipework/pipework
CNAME_DB=db
CNAME_PH=ph
DPSW_S1U_IP=192.168.11.50
MME_S1C_IP=192.168.10.51

## Note: remmeber to change the parent interface
  #docker network  create  -d macvlan \
    #--subnet=192.168.10.0/24 \
    #-o parent=vlan455 s1c
  #docker network  create  -d macvlan \
    #--subnet=192.168.11.0/24 \
    #-o parent=vlan456 s1u

# clean up
docker rm -f ${CNAME_DB} ${CNAME_PH}

# start the DB container
docker run --name ${CNAME_DB} -tid ${DHUB}/${DNSPACE}/aiodb:${DTAG}
echo "DB container starting up."
sleep 10
echo "Launching Open5GCore container."
# start the allinone container
docker run --name ${CNAME_PH} --cap-add=NET_ADMIN --link ${CNAME_DB} --env SQL_MGMT_IP=${CNAME_DB} \
  -tid ${DHUB}/${DNSPACE}/allinone:${DTAG}
  #-v $( pwd )/docker-entrypoint.sh:/opt/phoenix/dist/docker-entrypoint.sh:ro \
  #--ulimit core=99999999999:99999999999 \

# setup macvlan interfaces using pipework
${PIPEW} vlan455 -i s1c ${CNAME_PH} ${MME_S1C_IP}/24
${PIPEW} vlan456 -i s1u ${CNAME_PH} ${DPSW_S1U_IP}/24

docker ps

echo "hint: run docker exec -it ph tmux a"
