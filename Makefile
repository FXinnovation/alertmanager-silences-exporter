GO    	 := GO111MODULE=on go
pkgs      = $(shell $(GO) list ./... | grep -v /vendor/)
arch      = amd64  ## default architecture
platforms = darwin linux windows
package   = alertmanager-silences-exporter

PREFIX                  ?= $(shell pwd)
BIN_DIR                 ?= $(shell pwd)

all: vet format test build

build: ## build executable for current platform
	@echo ">> building..."
	@$(GO) build

xbuild: ## cross build executables for all defined platforms
	@echo ">> cross building executable(s)..."

	@for platform in $(platforms); do \
		echo "build for $$platform/$(arch)" ;\
		name=$(package)'-'$$platform'-'$(arch) ;\
		if [ $$platform = "windows" ]; then \
			name=$$name'.exe' ;\
		fi ;\
		echo $$name ;\
		GOOS=$$platform GOARCH=$(arch) $(GO) build -o $$name . ;\
	done

test:
	@echo ">> running tests.."
	@$(GO) test -v -short $(pkgs)

format: ## format code
	@echo ">> formatting code"
	@$(GO) fmt $(pkgs)

vet: ## vet code
	@echo ">> vetting code"
	@$(GO) vet $(pkgs)

lint: golint ## lint code
	@echo ">> linting code"
	@! golint $(pkgs) | grep '^'

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

golint: ## downloads golint
	@go get -u golang.org/x/lint/golint