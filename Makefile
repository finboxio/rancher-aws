DOCKERHUB_USER=finboxio

GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_COMMIT := $(shell git rev-parse HEAD)
GIT_REPO := $(shell git remote -v | grep origin | grep "(fetch)" | awk '{ print $$2 }')
GIT_DIRTY := $(shell git status --porcelain | wc -l)

VERSION := $(shell git describe --abbrev=0)
VERSION_DIRTY := $(shell git log --pretty=format:%h $(VERSION)..HEAD | wc -l)

BUILD_COMMIT := $(shell if [[ "$(GIT_DIRTY)" -gt "0" ]]; then echo $(GIT_COMMIT)+dev; else echo $(GIT_COMMIT); fi)
BUILD_COMMIT := $(shell echo $(BUILD_COMMIT) | cut -c1-12)
BUILD_VERSION := $(shell if [[ "$(VERSION_DIRTY)" -gt "0" ]]; then echo "$(VERSION)-$(BUILD_COMMIT)"; else echo $(VERSION); fi)
BUILD_VERSION := $(shell if [[ "$(VERSION_DIRTY)" -gt "0" ]] || [[ "$(GIT_DIRTY)" -gt "0" ]]; then echo "$(BUILD_VERSION)-dev"; else echo $(BUILD_VERSION); fi)
BUILD_VERSION := $(shell if [[ "$(GIT_BRANCH)" != "master" ]]; then echo $(GIT_BRANCH)-$(BUILD_VERSION); else echo $(BUILD_VERSION); fi)

DEBUG ?= "false"
DEBUG_FLAG := $(shell if [ "$(DEBUG)" == "true" ]; then echo "-debug"; fi)

packer_cache:
	@mkdir ~/.packer_cache &> /dev/null || true

info:
	@echo "git branch:      $(GIT_BRANCH)"
	@echo "git commit:      $(GIT_COMMIT)"
	@echo "git repo:        $(GIT_REPO)"
	@echo "git dirty:       $(GIT_DIRTY)"
	@echo "version:         $(VERSION)"
	@echo "version dirty:   $(VERSION_DIRTY)"
	@echo "build commit:    $(BUILD_COMMIT)"
	@echo "build version:   $(BUILD_VERSION)"

version:
	@echo $(BUILD_VERSION) | tr -d '\r' | tr -d '\n' | tr -d ' '

images: image.server image.host
	@echo built images at version $(BUILD_VERSION)

image.server:
	@cd images/server \
		&& docker build -t $(DOCKERHUB_USER)/rancher-aws-server:$(BUILD_VERSION) -t $(DOCKERHUB_USER)/rancher-aws-server:$(BUILD_VERSION)-latest -t $(DOCKERHUB_USER)/rancher-aws-server:latest . \
		&& docker push $(DOCKERHUB_USER)/rancher-aws-server:$(BUILD_VERSION) \
		&& docker push $(DOCKERHUB_USER)/rancher-aws-server:$(BUILD_VERSION)-latest \
		&& docker push $(DOCKERHUB_USER)/rancher-aws-server:latest

image.host:
	@cd images/host \
		&& docker build -t $(DOCKERHUB_USER)/rancher-aws-host:$(BUILD_VERSION) -t $(DOCKERHUB_USER)/rancher-aws-host:$(BUILD_VERSION)-latest -t $(DOCKERHUB_USER)/rancher-aws-host:latest . \
		&& docker push $(DOCKERHUB_USER)/rancher-aws-host:$(BUILD_VERSION) \
		&& docker push $(DOCKERHUB_USER)/rancher-aws-host:$(BUILD_VERSION)-latest \
		&& docker push $(DOCKERHUB_USER)/rancher-aws-host:latest

image.mms:
	@cd images/mms \
		&& docker build -t $(DOCKERHUB_USER)/mms:$(BUILD_VERSION) -t $(DOCKERHUB_USER)/mms:$(BUILD_VERSION)-latest -t $(DOCKERHUB_USER)/mms:latest . \
		&& docker push $(DOCKERHUB_USER)/mms:$(BUILD_VERSION) \
		&& docker push $(DOCKERHUB_USER)/mms:$(BUILD_VERSION)-latest \
		&& docker push $(DOCKERHUB_USER)/mms:latest

image.convoy:
	@cd images/convoy \
		&& docker build -t $(DOCKERHUB_USER)/convoy-ebs:$(BUILD_VERSION) -t $(DOCKERHUB_USER)/convoy-ebs:$(BUILD_VERSION)-latest -t $(DOCKERHUB_USER)/convoy-ebs:latest . \
		&& docker push $(DOCKERHUB_USER)/convoy-ebs:$(BUILD_VERSION) \
		&& docker push $(DOCKERHUB_USER)/convoy-ebs:$(BUILD_VERSION)-latest \
		&& docker push $(DOCKERHUB_USER)/convoy-ebs:latest

image.router:
	@cd images/router \
		&& docker build -t $(DOCKERHUB_USER)/rancher-router:$(BUILD_VERSION) -t $(DOCKERHUB_USER)/rancher-router:$(BUILD_VERSION)-latest -t $(DOCKERHUB_USER)/rancher-router:latest . \
		&& docker push $(DOCKERHUB_USER)/rancher-router:$(BUILD_VERSION) \
		&& docker push $(DOCKERHUB_USER)/rancher-router:$(BUILD_VERSION)-latest \
		&& docker push $(DOCKERHUB_USER)/rancher-router:latest

amis: ami.server ami.host

ami.server: packer_cache image.server
	@echo "Building server ami from $(GIT_BRANCH):$(GIT_COMMIT) of $(GIT_REPO)"
	@echo "Version $(BUILD_VERSION), Commit $(BUILD_COMMIT)"
	@export PACKER_CACHE_DIR=~/.packer_cache && cd amis/server && cat packer.json \
		| jq '.variables.version="${BUILD_VERSION}" \
		| .variables.branch="${GIT_BRANCH}" \
		| .variables.commit="${BUILD_COMMIT}" \
		| .variables.repository="${GIT_REPO}" \
		| .variables.dockerhub="${DOCKERHUB_USER}"' \
		| packer build -force $(DEBUG_FLAG) -

ami.host: packer_cache image.host
	@echo "Building host ami from $(GIT_BRANCH):$(GIT_COMMIT) of $(GIT_REPO)"
	@echo "Version $(BUILD_VERSION), Commit $(BUILD_COMMIT)"
	@export PACKER_CACHE_DIR=~/.packer_cache && cd amis/host && cat packer.json \
		| jq '.variables.version="${BUILD_VERSION}" \
		| .variables.branch="${GIT_BRANCH}" \
		| .variables.commit="${BUILD_COMMIT}" \
		| .variables.repository="${GIT_REPO}" \
		| .variables.dockerhub="${DOCKERHUB_USER}"' \
		| packer build -force $(DEBUG_FLAG) -

cluster.plan:
	@echo "Plan changes to terraform infrastructure"
	@cd deployment \
	  && terraform get \
	  && terraform plan -state=.tfstate/terraform.tfstate

cluster.plan.target:
	@echo "Plan changes to terraform server infrastructure"
	@cd deployment \
	  && terraform get \
	  && terraform plan -state=.tfstate/terraform.tfstate -target=${TARGET}

cluster.apply:
	@echo "Applying changes to terraform infrastructure"
	@cd deployment \
		&& terraform get \
	  && terraform apply -state=.tfstate/terraform.tfstate

cluster.apply.target:
	@echo "Applying changes to terraform server infrastructure"
	@cd deployment \
		&& terraform get \
	  && terraform apply -state=.tfstate/terraform.tfstate -target=${TARGET}

cluster.destroy:
	@echo "Destroying terraform infrastructure"
	@cd deployment \
		&& terraform get \
		&& terraform destroy -state=.tfstate/terraform.tfstate

cluster.outputs:
	@cd deployment \
		&& terraform output -state=.tfstate/terraform.tfstate

