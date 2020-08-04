#!/bin/sh

# start the DB container

DHUB=dockerhub.fokus.fraunhofer.de:5000
DNSPACE=phoenix/docker-phoenix/phoenix-bin

docker run --rm --name db -it local/ph-db

docker run --rm --name ph -it --link db ${DHUB}/${DNSPACE}/allinone

## Note: remmeber to change the parent interface

docker network inspect s1c >/dev/null || \
  docker network  create  -d macvlan \
    --subnet=192.168.10.0/24 \
    -o parent=vlan455 s1c

docker network inspect s1u >/dev/null || \
  docker network  create  -d macvlan \
    --subnet=192.168.11.0/24 \
    -o parent=vlan456 s1u

docker create --rm --name ph --link db -it ${DHUB}/${DNSPACE}/allinone; \
 docker network connect s1c ph --ip 192.168.10.51; docker network connect s1u ph --ip 192.168.11.50; \
 docker start -ia ph

echo "hint: run docker exec -it ph tmux a"
