bold=$(shell echo "\033[1;30m")
highlight=$(shell echo "\033[36m")
normal=$(shell echo "\033[0m")
print = @printf "\n$(bold)$(1)$(normal)\n\n"

.PHONY: clean
clean: ## Clean local Terraform cache
	$(call print,Cleaning local Terraform cache...)
	rm -rf .terraform

.PHONY: format
format: ## Format the Terraform configs
	$(call print,Formatting Terraform...)
	@terraform fmt --recursive

.PHONY: help
help: ## Display this help screen
	$(call print,Available make targets:)
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "$(highlight)%-20s$(normal) %s\n", $$1, $$2}'
	@printf "\n"

.PHONY: lint
lint: .terraform ## Lint the Terraform configs
	$(call print,Linting Terraform...)
	@terraform validate

.PHONY: init
init: ## Initialize the Terraform configs
	$(call print,Initializing Terraform...)
	@terraform init

.PHONY: destroy
destroy: ## Destroy the Terraform configs
	$(call print,Destroying Terraform...)
	@terraform destroy

.PHONY: plan
plan: ## Plan the Terraform configs
	$(call print,Planning Terraform...)
	@terraform plan

.PHONY: security-check
security-check: ## Run tfsec on the Terraform configs
	$(call print,Running tfsec...)
	@tfsec
