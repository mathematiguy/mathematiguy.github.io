IMAGE_NAME := $(shell basename `git rev-parse --show-toplevel` | tr '[:upper:]' '[:lower:]')
GIT_TAG ?= $(shell git log --oneline | head -n1 | awk '{print $$1}')
DOCKER_REGISTRY := mathematiguy
IMAGE := $(DOCKER_REGISTRY)/$(IMAGE_NAME)
HAS_DOCKER ?= $(shell which docker)
RUN ?= $(if $(HAS_DOCKER), docker run $(DOCKER_ARGS) --rm -v $$(pwd):/code -w /code -u $(UID):$(GID) $(IMAGE))
UID ?= $(shell id -u)
GID ?= $(shell id -g)
DOCKER_ARGS ?=

.PHONY: docker docker-push docker-pull enter enter-root

docker:
	docker build $(DOCKER_ARGS) --tag $(IMAGE):$(GIT_TAG) .
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

docker-push:
	docker push $(IMAGE):$(GIT_TAG)
	docker push $(IMAGE):latest

docker-pull:
	docker pull $(IMAGE):$(GIT_TAG)
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

CMD ?=
hugo:
	$(RUN)

server:
	$(RUN) server $(CMD)

help:
	$(RUN) help $(CMD)
