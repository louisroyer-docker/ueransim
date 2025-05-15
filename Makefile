.PHONY: docker

all: docker/ue docker/gnb
docker/%:
	docker buildx build -t louisroyer/ueransim-$(@F) ./$(@F)
