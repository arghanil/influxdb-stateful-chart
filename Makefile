check-var = $(if $(strip $($1)),,$(error var for "$1" is empty))
help:
	@awk 'BEGIN {FS = ":.*?## "} /^[\/a-zA-Z_-]+:.*?## / {sub("\\\\n",sprintf("\n%22c"," "), $$2);printf "\033[36minfluxdb-stateful-chart \033[0m%-16s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check-var = $(if $(strip $($1)),,$(error var for "$1" is empty))
stack_lower := $(shell echo $(stack) | tr A-Z a-z)

require_stack:
	$(call check-var,stack)

upgrade/tiller: ## Upgrade tiller to the latest version.
	@helm init --tiller-namespace testns --upgrade

install: require_stack ## Deploy stack into kubernetes. vars: stack
	@helm install --name influxdb-stateful-chart-$(stack_lower) .

delete: ## delete stack from reference
	@helm delete  --purge influxdb-stateful-chart-$(stack_lower)

upgrade: require_stack ## upgrade the release
	@helm upgrade influxdb-stateful-chart-$(stack_lower) .
