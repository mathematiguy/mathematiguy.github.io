IMAGE_NAME := $(shell basename `git rev-parse --show-toplevel` | tr '[:upper:]' '[:lower:]')
GIT_TAG ?= $(shell git log --oneline | head -n1 | awk '{print $$1}')
DOCKER_REGISTRY := mathematiguy
IMAGE := $(DOCKER_REGISTRY)/$(IMAGE_NAME)
HAS_DOCKER ?= $(shell which docker)
RUN ?= $(if $(HAS_DOCKER), docker run $(DOCKER_ARGS) --rm -v $$(pwd):/code -w /code -u $(UID):$(GID) $(IMAGE))
UID ?= ubuntu
GID ?= ubuntu
DOCKER_ARGS ?=

.PHONY: docker docker-push docker-pull enter enter-root

server: DOCKER_ARGS=-p 1313:1313
server:
	$(RUN) hugo server --bind=0.0.0.0 --baseURL http://0.0.0.0:1313

container:
	docker build $(DOCKER_ARGS) --tag $(IMAGE):$(GIT_TAG) .
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

docker-push:
	docker push $(IMAGE):$(GIT_TAG)
	docker push $(IMAGE):latest

docker-pull:
	docker pull $(IMAGE):$(GIT_TAG)
	docker tag $(IMAGE):$(GIT_TAG) $(IMAGE):latest

shell: DOCKER_ARGS=-it
shell:
	$(RUN) bash

root-shell: DOCKER_ARGS=-it
root-shell: UID=root
root-shell: GID=root
root-shell:
	$(RUN) bash
