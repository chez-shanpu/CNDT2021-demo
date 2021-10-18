SHELL:=/bin/bash

UNAME=$(shell uname)

BIN_DIR=/usr/local/bin

CILIUM=cilium

DOCKER=docker
DOCKER_DIR=./Docker
UBUNTU_IMAGE=shanpu-ubuntu:latest
NGINX_IMAGE=shanpu-nginx:latest

KIND=kind
KIND_CONFIG=./cluster/kind-config.yaml
CLUSTER_NAME=cndt2021



$(BIN_DIR)/$(CILIUM):
	@echo "Install Cilium CLI"
ifeq ($(UNAME), Darwin)
	curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-darwin-amd64.tar.gz{,.sha256sum}
	shasum -a 256 -c cilium-darwin-amd64.tar.gz.sha256sum
	sudo tar xzvfC cilium-darwin-amd64.tar.gz /usr/local/bin
	rm cilium-darwin-amd64.tar.gz{,.sha256sum}
else
ifeq ($(UNAME), Linux)
	curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
	sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
	sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
	rm cilium-linux-amd64.tar.gz{,.sha256sum}
else
	@echo "$(UNAME) is not supported, sorry..."
endif
endif


.PHONY: cli
cli: $(BIN_DIR)/$(CILIUM)

.PHONY: install
install: cli
	$(CILIUM) install

.PHONY: cluster
cluster:
	$(KIND) create cluster --config=$(KIND_CONFIG) --name=$(CLUSTER_NAME) --wait 5m

images-build:
	$(DOCKER) image build -t $(UBUNTU_IMAGE) -f $(DOCKER)/ubuntu.Dockerfile $(DOCKER)
	$(DOCKER) image build -t $(NGINX_IMAGE) -f $(DOCKER)/nginx.Dockerfile $(DOCKER)

images-load:
	$(KIND) load docker-image --name $(CLUSTER_NAME) $(UBUNTU_IMAGE)
	$(KIND) load docker-image --name $(CLUSTER_NAME) $(NGINX_IMAGE)

.PHONY: images
images: images-build images-load

.PHONY: setup
setup: cluster install images
	
.PHONY: clean
clean:
	$(KIND) delete clusters $(CLUSTER_NAME)

.DEFAULT_GOAL=all
all: setup
