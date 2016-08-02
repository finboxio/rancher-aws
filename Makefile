DOCKERHUB_USER=finboxio

GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT := $(shell git rev-parse HEAD)
GIT_REPO := $(shell git remote -v | grep origin | grep "(fetch)" | awk '{ print $$2 }')
GIT_DIRTY := $(shell git status --porcelain | wc -l)

VERSION := $(shell git describe --abbrev=0)
VERSION_DIRTY := $(shell git log --pretty=format:%h $(VERSION)..HEAD | wc -l)

BUILD_COMMIT := $(shell if [ "$(GIT_DIRTY)" -gt "0" ]; then echo $(GIT_COMMIT)+dev; else echo $(GIT_COMMIT); fi)
BUILD_VERSION := $(shell if [ "$(VERSION_DIRTY)" -gt "0" ] || [ "$(GIT_DIRTY)" -gt "0" ]; then echo $(VERSION)-dev; else echo $(VERSION); fi)
BUILD_VERSION := $(shell if [ "$(GIT_BRANCH)" != "master" ]; then echo $(GIT_BRANCH)-$(VERSION); else echo $(VERSION); fi)

DEBUG ?= "false"
DEBUG_FLAG := $(shell if [ "$(DEBUG)" == "true" ]; then echo "-debug"; fi)

packer_cache:
	@mkdir ~/.packer_cache &> /dev/null || true

version:
	@echo $(BUILD_VERSION) | tr -d '\r' | tr -d '\n' | tr -d ' '

images: image.server image.host
	@echo built images at version $(BUILD_VERSION)

image.server:
	@cd modules/server/docker \
		&& docker build -t $(DOCKERHUB_USER)/rancher-asg-server:$(BUILD_VERSION) -t $(DOCKERHUB_USER)/rancher-asg-server:$(BUILD_VERSION)-latest -t $(DOCKERHUB_USER)/rancher-asg-server:latest . \
		&& docker push $(DOCKERHUB_USER)/rancher-asg-server:$(BUILD_VERSION) \
		&& docker push $(DOCKERHUB_USER)/rancher-asg-server:$(BUILD_VERSION)-latest \
		&& docker push $(DOCKERHUB_USER)/rancher-asg-server:latest

image.host:
	@cd modules/environment/docker \
		&& docker build -t $(DOCKERHUB_USER)/rancher-asg-host:$(BUILD_VERSION) -t $(DOCKERHUB_USER)/rancher-asg-host:$(BUILD_VERSION)-latest -t $(DOCKERHUB_USER)/rancher-asg-host:latest . \
		&& docker push $(DOCKERHUB_USER)/rancher-asg-host:$(BUILD_VERSION) \
		&& docker push $(DOCKERHUB_USER)/rancher-asg-host:$(BUILD_VERSION)-latest \
		&& docker push $(DOCKERHUB_USER)/rancher-asg-host:latest

amis: ami.server ami.host

ami.server: packer_cache image.server
	@echo "Building server ami from $(GIT_BRANCH):$(GIT_COMMIT) of $(GIT_REPO)"
	@echo "Version $(BUILD_VERSION), Commit $(BUILD_COMMIT)"
	@export PACKER_CACHE_DIR=~/.packer_cache && cd modules/server/packer && cat packer.json \
		| jq '.variables.version="${BUILD_VERSION}" \
		| .variables.branch="${GIT_BRANCH}" \
		| .variables.role="server" \
		| .variables.commit="${BUILD_COMMIT}" \
		| .variables.repository="${GIT_REPO}" \
		| .variables.dockerhub="${DOCKERHUB_USER}"' \
		| packer build -force $(DEBUG_FLAG) -

ami.host: packer_cache image.host
	@echo "Building host ami from $(GIT_BRANCH):$(GIT_COMMIT) of $(GIT_REPO)"
	@echo "Version $(BUILD_VERSION), Commit $(BUILD_COMMIT)"
	@export PACKER_CACHE_DIR=~/.packer_cache && cd modules/environment/packer && cat packer.json \
		| jq '.variables.version="${BUILD_VERSION}" \
		| .variables.branch="${GIT_BRANCH}" \
		| .variables.role="host" \
		| .variables.commit="${BUILD_COMMIT}" \
		| .variables.repository="${GIT_REPO}" \
		| .variables.dockerhub="${DOCKERHUB_USER}"' \
		| packer build -force $(DEBUG_FLAG) -

cluster.plan:
	@echo "Plan changes to terraform infrastructure"
	@terraform get
	@terraform plan

cluster.apply:
	@echo "Applying changes to terraform infrastructure"
	@terraform get
	@terraform apply

cluster.destroy:
	@echo "Destroying terraform infrastructure" && terraform destroy || true
