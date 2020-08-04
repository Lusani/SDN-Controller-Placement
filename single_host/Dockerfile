FROM dockerhub.fokus.fraunhofer.de:5000/phoenix/docker-phoenix/phoenix-bin:latest

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
	&& apt-get -y install --no-install-recommends \
	tmux iproute2 iptables mariadb-client \
	&& apt-get -y clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt/phoenix/dist

COPY . .

CMD ./docker-entrypoint.sh
