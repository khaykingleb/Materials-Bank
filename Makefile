SHELL := /bin/bash
VERSION := 0.1.0

##==================================================================================================
##@ Helper

help: ## Display help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage: \033[36m\033[0m\n"} /^[a-zA-Z\.\%-]+:.*?##/ { printf "  \033[36m%-24s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
.PHONY: help

####==================================================================================================
##@ General Initialization

install-dotenv:  ## Install dotenv to read .env file
ifeq ($(shell echo $$SHELL), /bin/bash)
	curl -sfL https://direnv.net/install.sh | bash
	echo $(shell echo 'eval "$$(direnv hook bash)"') >> ~/.bashrc
endif

##==================================================================================================
##@ Repo Initialization

repo-deps:  ## Install dependencies
	pip install poetry
	poetry config virtualenvs.in-project true
	poetry install

repo-pre-commit:  ## Install pre-commit
	poetry run pre-commit install
	poetry run pre-commit install -t commit-msg

repo-env:  ## Configure environment variables
	cat .test.env  > .env
	echo "dotenv" > .envrc

repo-init: repo-deps repo-pre-commit repo-env  ## Initialize repository by executing above commands

##==================================================================================================
##@ Miscellaneous

upd-pre-commit:  ## Update pre-commit hooks
	poetry run pre-commit autoupdate

gen-secrets-baseline:  ## Create .secrets.baseline file
	poetry run detect-secrets scan > .secrets.baseline

clean:  ## Delete junk files
	find . -type f -name "*.DS_Store" -ls -delete
	find . | grep -E "(__pycache__|\.pyc|\.pyo)" | xargs rm -rf
	find . | grep -E ".pytest_cache" | xargs rm -rf
	find . | grep -E ".ipynb_checkpoints" | xargs rm -rf
	find . | grep -E ".trash" | xargs rm -rf
	rm -f .coverage
.PHONY: clean
