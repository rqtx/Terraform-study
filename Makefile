# import env config

cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

# Get the latest tag
TAG=$(shell git describe --tags --abbrev=0)
GIT_COMMIT=$(shell git log -1 --format=%h)
TERRAFORM_VERSION=0.12.24

# HELP
# This will output the help for each task
# thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help


terraform-init: ## Run terraform init to download all necessary plugins
	docker run --rm -v $$PWD:/app -v $$HOME/.ssh:/root/.ssh -w /app -e AWS_ACCESS_KEY_ID=$$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$$AWS_SECRET_ACCESS_KEY hashicorp/terraform:$(TERRAFORM_VERSION) init -upgrade=true

terraform-plan: ## Exec terraform plan and puts it on a file called tfplan
	docker run --rm -v $$PWD:/app -v $$HOME/.ssh:/root/.ssh -w /app -e AWS_ACCESS_KEY_ID=$$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$$AWS_SECRET_ACCESS_KEY hashicorp/terraform:$(TERRAFORM_VERSION) plan -out=tfplan

terraform-apply: ## Uses tfplan to applythe changes on AWS
	docker run --rm -v $$PWD:/app -v $$HOME/.ssh:/root/.ssh -w /app -e AWS_ACCESS_KEY_ID=$$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$$AWS_SECRET_ACCESS_KEY hashicorp/terraform:$(TERRAFORM_VERSION) apply tfplan

terraform-destroy: ## Uses tfplan to apply the changes on AWS
	docker run --rm -v $$PWD:/app -v $$HOME/.ssh:/root/.ssh -w /app -e AWS_ACCESS_KEY_ID=$$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$$AWS_SECRET_ACCESS_KEY hashicorp/terraform:$(TERRAFORM_VERSION) destroy -auto-aprove

terraform-bash: ## Run bash to troubleshooting
	docker run --rm -v $$PWD:/app -v $$HOME/.ssh:/root/.ssh -w /app -e AWS_ACCESS_KEY_ID=$$AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY=$$AWS_SECRET_ACCESS_KEY --entrypoint "" hashicorp/terraform:$(TERRAFORM_VERSION) sh
