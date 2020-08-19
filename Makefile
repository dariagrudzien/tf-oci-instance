# https://www.thapaliya.com/en/writings/well-documented-makefiles/

.DEFAULT_GOAL := help
.PHONY: init, output, clean, check, format, help

init: ## Initialize terraform
	terraform init

output: ## Show terraform output
	terraform output

clean: ## Nuke the terraform directory
	# don't echo this output
	@rm -rf .terraform/

check: ## Check the formatting of terraform files
	terraform fmt -check=true

format: ## Format the terraform files
	terraform fmt

help:  ## Display help
	@awk 'BEGIN {FS = ":.*##"; printf "Usage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
	@printf "\n\033[1mTerraform groups\033[0m\n"
	@for GRP in $(GROUPS); do \
		printf "  \033[36m%-15s\033[0m\n" $$GRP; \
	done
	@printf "\n"

