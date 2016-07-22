DOCKERHUB_USER=finboxio

GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT := $(shell git rev-parse HEAD)
GIT_REPO := $(shell git remote -v | grep origin | grep "(fetch)" | awk '{ print $$2 }')
GIT_DIRTY := $(shell git status --porcelain | wc -l)

VERSION := $(shell cat package.json | jq '.version' -r)
VERSION_DIRTY := $(shell git log --pretty=format:%h v$(VERSION)..HEAD | wc -l)

BUILD_COMMIT := $(shell if [ "$(GIT_DIRTY)" -gt "0" ]; then echo $(GIT_COMMIT)+dev; else echo $(GIT_COMMIT); fi)
BUILD_VERSION := $(shell if [ "$(VERSION_DIRTY)" -gt "0" ] || [ "$(GIT_DIRTY)" -gt "0" ]; then echo $(VERSION)-dev; else echo $(VERSION); fi)

DEBUG ?= "false"
DEBUG_FLAG := $(shell if [ "$(DEBUG)" == "true" ]; then echo "-debug"; fi)

packer_cache:
	@mkdir ~/.packer_cache &> /dev/null || true

version:
	@echo $(BUILD_VERSION) | tr -d '\r' | tr -d '\n' | tr -d ' '

containers: container.server
	@echo built containers at version $(BUILD_VERSION)

container.server:
	@cd images/asg \
		&& docker build -t $(DOCKERHUB_USER)/rancher-asg-server:$(BUILD_VERSION) . \
		&& docker push $(DOCKERHUB_USER)/rancher-asg-server:$(BUILD_VERSION)

images: image.server

image.server: packer_cache container.server
	@echo "Building server image from $(GIT_BRANCH):$(GIT_COMMIT) of $(GIT_REPO)"
	@echo "Version $(BUILD_VERSION), Commit $(BUILD_COMMIT)"
	@export PACKER_CACHE_DIR=~/.packer_cache && cat server/packer.json \
		| jq '.variables.version="${BUILD_VERSION}" \
		| .variables.branch="${GIT_BRANCH}" \
		| .variables.role="server" \
		| .variables.commit="${BUILD_COMMIT}" \
		| .variables.repository="${GIT_REPO}"' \
		| packer build -force $(DEBUG_FLAG) -
