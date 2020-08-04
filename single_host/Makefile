all: 
	echo "Usage: make <login|upload|build>"
login:
	docker login dockerhub.fokus.fraunhofer.de:5000

upload: Dockerfile
	docker push dockerhub.fokus.fraunhofer.de:5000/phoenix/docker-phoenix/phoenix-bin/allinone:latest 

build: Dockerfile
	docker tag dockerhub.fokus.fraunhofer.de:5000/phoenix/docker-phoenix/phoenix-bin/allinone:latest dockerhub.fokus.fraunhofer.de:5000/phoenix/docker-phoenix/phoenix-bin/allinone:tmp || true
	docker rmi dockerhub.fokus.fraunhofer.de:5000/phoenix/docker-phoenix/phoenix-bin/allinone:latest || true
	docker build -t dockerhub.fokus.fraunhofer.de:5000/phoenix/docker-phoenix/phoenix-bin/allinone:latest . && docker rmi dockerhub.fokus.fraunhofer.de:5000/phoenix/docker-phoenix/phoenix-bin/allinone:tmp || true
